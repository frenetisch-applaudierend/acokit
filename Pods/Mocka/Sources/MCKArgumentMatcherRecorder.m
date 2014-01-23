//
//  MCKArgumentMatcherRecorder.m
//  mocka
//
//  Created by Markus Gasser on 14.10.12.
//  Copyright (c) 2012 Markus Gasser. All rights reserved.
//

#import "MCKArgumentMatcherRecorder.h"
#import "MCKTypeEncodings.h"
#import "MCKMockingContext.h"


@interface MCKArgumentMatcherRecorder ()

@property (nonatomic, assign) NSUInteger primitiveMatcherCount;
@property (nonatomic, readonly) NSMutableArray *mutableArgumentMatchers;

@end

@implementation MCKArgumentMatcherRecorder

#pragma mark - Initialization

- (instancetype)initWithMockingContext:(MCKMockingContext *)context {
    if ((self = [super init])) {
        _mockingContext = context;
        _mutableArgumentMatchers = [NSMutableArray array];
    }
    return self;
}


#pragma mark - Adding Matchers

- (NSArray *)argumentMatchers {
    return [self.mutableArgumentMatchers copy];
}

- (NSArray *)collectAndReset {
    NSArray *matchers = self.argumentMatchers;
    [self reset];
    return matchers;
}

- (UInt8)addPrimitiveArgumentMatcher:(id<MCKArgumentMatcher>)matcher {
    self.primitiveMatcherCount++;
    return [self addArgumentMatcher:matcher];
}

- (UInt8)addObjectArgumentMatcher:(id<MCKArgumentMatcher>)matcher {
    return [self addArgumentMatcher:matcher];
}

- (UInt8)addArgumentMatcher:(id<MCKArgumentMatcher>)matcher {
    if ([self.mutableArgumentMatchers count] > UINT8_MAX) {
        [self.mockingContext failWithReason:@"Only UINT8_MAX matchers supported"];
        return UINT8_MAX;
    }
    [self.mutableArgumentMatchers addObject:matcher];
    return ([self.mutableArgumentMatchers count] - 1);
}

- (void)reset {
    [self.mutableArgumentMatchers removeAllObjects];
    self.primitiveMatcherCount = 0;
}


#pragma mark - Validating the Recorder

- (BOOL)isValidForMethodSignature:(NSMethodSignature *)signature reason:(NSString **)reason {
    if (self.primitiveMatcherCount == 0) {
        return YES;
    }
    
    NSUInteger signaturePrimitiveArgs = [self countPrimitiveArgumentsOfSignature:signature];
    if (signaturePrimitiveArgs > self.primitiveMatcherCount) {
        if (reason != NULL) { *reason = @"When using argument matchers, all non-object arguments must be matchers"; }
        return NO;
    } else if (signaturePrimitiveArgs < self.primitiveMatcherCount) {
        if (reason != NULL) { *reason = @"Too many primitive matchers for this method invocation"; }
        return NO;
    }
    return YES;
}

- (NSUInteger)countPrimitiveArgumentsOfSignature:(NSMethodSignature *)signature {
    NSUInteger primitiveArgumentCount = 0;
    for (NSUInteger argIndex = 2; argIndex < [signature numberOfArguments]; argIndex++) {
        if (![MCKTypeEncodings isObjectType:[signature getArgumentTypeAtIndex:argIndex]]) {
            primitiveArgumentCount++;
        }
    }
    return primitiveArgumentCount;
}

@end
