//
//  MCKStub.m
//  mocka
//
//  Created by Markus Gasser on 18.07.12.
//  Copyright (c) 2012 Markus Gasser. All rights reserved.
//

#import "MCKStub.h"
#import "MCKInvocationPrototype.h"
#import "MCKBlockWrapper.h"
#import "MCKMockingContext.h"
#import "MCKTypeEncodings.h"


@interface MCKStub ()

@property (nonatomic, readonly) NSMutableArray *recordedPrototypes;
@property (nonatomic, strong) MCKBlockWrapper *stubBlockWrapper;

@end

@implementation MCKStub


#pragma mark - Initialization

- (instancetype)init {
    if ((self = [super init])) {
        _recordedPrototypes = [NSMutableArray array];
    }
    return self;
}


#pragma mark - Configuration

- (NSArray *)invocationPrototypes {
    return [self.recordedPrototypes copy];
}

- (void)setStubBlock:(id)stubBlock {
    NSParameterAssert(stubBlock != nil);
    
    MCKBlockWrapper *wrapper = [MCKBlockWrapper wrapperForBlock:stubBlock];
    if (![self blockMatchesRecordedInvocations:wrapper]) {
        [[MCKMockingContext currentContext] failWithReason:@"Signature of stub block is incompatible with stubbed invocations"];
        return;
    }
    
    self.stubBlockWrapper = wrapper;
}

- (id)stubBlock {
    return self.stubBlockWrapper.block;
}

- (void)addInvocationPrototype:(MCKInvocationPrototype *)prototype {
    [self.recordedPrototypes addObject:prototype];
}


#pragma mark - Matching and Applying Stub

- (BOOL)matchesForInvocation:(NSInvocation *)candidate {
    for (MCKInvocationPrototype *prototype in self.recordedPrototypes) {
        if ([prototype matchesInvocation:candidate]) {
            return YES;
        }
    }
    return NO;
}

- (void)applyToInvocation:(NSInvocation *)invocation {
    NSAssert(self.stubBlockWrapper != nil, @"Should have a stub block by now");
    
    [self copyArgumentsFromInvocation:invocation toBlock:self.stubBlockWrapper];
    [self.stubBlockWrapper invoke];
    [self copyReturnValueFromBlock:self.stubBlockWrapper toInvocation:invocation];
}


#pragma mark - Testing wether Block and Invocations Match

- (BOOL)blockMatchesRecordedInvocations:(MCKBlockWrapper *)block {
    for (MCKInvocationPrototype *prototype in self.recordedPrototypes) {
        if (![self block:block matchesInvocation:prototype.invocation]) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)block:(MCKBlockWrapper *)block matchesInvocation:(NSInvocation *)invocation {
    if (![self block:block matchesReturnTypeOfInvocation:invocation]) {
        return NO;
    }
    
    return ([self blockHasEmptyArgumentList:block]
            || [self block:block matchesFullArgumentsOfInvocation:invocation]
            || [self block:block matchesReducedArgumentsOfInvocation:invocation]);
}

- (BOOL)block:(MCKBlockWrapper *)block matchesReturnTypeOfInvocation:(NSInvocation *)invocation {
    const char *blockType = block.blockSignature.methodReturnType;
    return ([MCKTypeEncodings isType:blockType equalToType:@encode(void)]
            || [MCKTypeEncodings isType:blockType equalToType:invocation.methodSignature.methodReturnType]);
}

- (BOOL)blockHasEmptyArgumentList:(MCKBlockWrapper *)block {
    return (block.blockSignature.numberOfArguments <= 1);
}

- (BOOL)block:(MCKBlockWrapper *)block matchesFullArgumentsOfInvocation:(NSInvocation *)invocation {
    return [self block:block matchesArgumentsOfInvocation:invocation fromOffset:0];
}

- (BOOL)block:(MCKBlockWrapper *)block matchesReducedArgumentsOfInvocation:(NSInvocation *)invocation {
    return [self block:block matchesArgumentsOfInvocation:invocation fromOffset:2];
}

- (BOOL)block:(MCKBlockWrapper *)block matchesArgumentsOfInvocation:(NSInvocation *)invocation fromOffset:(NSUInteger)offset {
    if ((block.blockSignature.numberOfArguments - 1) != (invocation.methodSignature.numberOfArguments - offset)) {
        return NO; // wrong argument count, no need to actually check types
    }
    
    for (NSUInteger argIndex = 0; argIndex < (block.blockSignature.numberOfArguments - 1); argIndex++) {
        if (![MCKTypeEncodings isType:[invocation.methodSignature getArgumentTypeAtIndex:(argIndex + offset)]
                          equalToType:[block getParameterTypeAtIndex:argIndex]]) {
            return NO;
        }
    }
    return YES;
}


#pragma mark - Copying Block and Invocation Arguments

- (void)copyArgumentsFromInvocation:(NSInvocation *)invocation toBlock:(MCKBlockWrapper *)block {
    if (block.blockSignature.numberOfArguments == 1) {
        return; // block has no arguments
    }
    
    if ([self block:block matchesFullArgumentsOfInvocation:invocation]) {
        [self copyArgumentsFromInvocation:invocation toBlock:block withOffset:0];
    } else if ([self block:block matchesReducedArgumentsOfInvocation:invocation]) {
        [self copyArgumentsFromInvocation:invocation toBlock:block withOffset:2];
    } else {
        NSAssert(NO, @"This condition should have been tested when setting the block");
    }
}

- (void)copyArgumentsFromInvocation:(NSInvocation *)invocation toBlock:(MCKBlockWrapper *)block withOffset:(NSUInteger)offset {
    void *argValueHolder = malloc(invocation.methodSignature.frameLength); // max length for any argument
    for (NSUInteger argIndex = 0; argIndex < (block.blockSignature.numberOfArguments - 1); argIndex++) {
        [invocation getArgument:argValueHolder atIndex:(argIndex + offset)];
        [block setParameter:argValueHolder atIndex:argIndex];
    }
    free(argValueHolder);
}

- (void)copyReturnValueFromBlock:(MCKBlockWrapper *)block toInvocation:(NSInvocation *)invocation {
    if (block.blockSignature.methodReturnLength == 0 || invocation.methodSignature.methodReturnLength == 0) {
        return;
    }
    
    NSAssert(block.blockSignature.methodReturnLength == invocation.methodSignature.methodReturnLength, @"Weird return sizes");
    
    void *returnValueHolder = malloc(invocation.methodSignature.methodReturnLength);
    [block getReturnValue:returnValueHolder];
    [invocation setReturnValue:returnValueHolder];
    free(returnValueHolder);
}

@end
