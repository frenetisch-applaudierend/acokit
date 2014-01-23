//
//  MCKInvocationPrototype.m
//  mocka
//
//  Created by Markus Gasser on 27.9.2013.
//
//

#import "MCKInvocationPrototype.h"

#import "MCKArgumentMatcher.h"
#import "MCKExactArgumentMatcher.h"
#import "MCKHamcrestArgumentMatcher.h"

#import "MCKTypeEncodings.h"
#import "NSInvocation+MCKArgumentHandling.h"


@implementation MCKInvocationPrototype

#pragma mark - Initialization

- (instancetype)initWithInvocation:(NSInvocation *)invocation argumentMatchers:(NSArray *)argumentMatchers {
    if ((self = [super init])) {
        _invocation = invocation;
        _argumentMatchers= [self prepareOrderedArgumentMatchersFromInvocation:invocation matchers:argumentMatchers];
    }
    return self;
}

- (instancetype)initWithInvocation:(NSInvocation *)invocation {
    return [self initWithInvocation:invocation argumentMatchers:@[]];
}


#pragma mark - Preparing Argument Matchers

- (NSArray *)prepareOrderedArgumentMatchersFromInvocation:(NSInvocation *)invocation matchers:(NSArray *)matchers {
    NSMutableArray *orderedMatchers = [NSMutableArray array];
    for (NSUInteger argIndex = 2; argIndex < invocation.methodSignature.numberOfArguments; argIndex++) {
        id<MCKArgumentMatcher> matcher = [self matcherAtIndex:argIndex forInvocation:invocation matchers:matchers];
        [orderedMatchers addObject:matcher];
    }
    return orderedMatchers;
}

- (id<MCKArgumentMatcher>)matcherAtIndex:(NSUInteger)index forInvocation:(NSInvocation *)invocation matchers:(NSArray *)matchers {
    BOOL isObjectArg = [MCKTypeEncodings isObjectType:[invocation.methodSignature getArgumentTypeAtIndex:index]];
    BOOL hasProvidedMatchers = ([matchers count] > 0);
    
    if (isObjectArg) {
        return [self wrapObjectInMatcherIfNeeded:[invocation mck_objectParameterAtIndex:(index - 2)]];
    } else if (hasProvidedMatchers) {
        return [matchers objectAtIndex:[self primitiveMatcherIndexFromInvocation:invocation argumentIndex:index]];
    } else {
        return [MCKExactArgumentMatcher matcherWithArgument:[invocation mck_serializedParameterAtIndex:(index - 2)]];
    }
}

- (id<MCKArgumentMatcher>)wrapObjectInMatcherIfNeeded:(id)object {
    if ([object conformsToProtocol:@protocol(MCKArgumentMatcher)]) {
        return object;
    } else if ([self hamcrestMatcherProtocol] != nil && [object conformsToProtocol:[self hamcrestMatcherProtocol]]) {
        return [MCKHamcrestArgumentMatcher matcherWithHamcrestMatcher:object];
    } else {
        return [MCKExactArgumentMatcher matcherWithArgument:object];
    }
}

- (NSUInteger)primitiveMatcherIndexFromInvocation:(NSInvocation *)invocation argumentIndex:(NSUInteger)index {
    NSUInteger paramSize = [invocation mck_sizeofParameterAtIndex:(index - 2)];
    NSAssert(paramSize >= 1, @"Minimum byte size not given");
    UInt8 buffer[paramSize]; memset(buffer, 0, paramSize);
    [invocation getArgument:buffer atIndex:index];
    return mck_matcherIndexForArgumentBytes(buffer);
}

- (Protocol *)hamcrestMatcherProtocol {
    static Protocol *hamcrestProtocol = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hamcrestProtocol = NSProtocolFromString(@"HCMatcher");
    });
    return hamcrestProtocol;
}


#pragma mark - Calculated Properties

- (NSString *)methodName {
    return [NSString stringWithFormat:@"-[%@ %@]", self.invocation.target, NSStringFromSelector(self.invocation.selector)];
}


#pragma mark - Matching Invocations

- (BOOL)matchesInvocation:(NSInvocation *)candidate {
    NSParameterAssert(candidate != nil);
    
    // check simple cases
    if ((self.invocation.target != candidate.target) || (self.invocation.selector != candidate.selector)) {
        return NO;
    }
    
    // match arguments
    NSUInteger argIndex = 2;
    for (id<MCKArgumentMatcher> matcher in self.argumentMatchers) {
        if (![matcher matchesCandidate:[candidate mck_serializedParameterAtIndex:(argIndex - 2)]]) {
            return NO;
        }
        argIndex++;
    }
    
    return YES;
}


#pragma mark - Equality Testing

- (BOOL)isEqual:(id)object {
    if (object == self) { return YES; }
    else if (object == nil || [object class] != [self class]) { return NO; }
    return [self isEqualToInvocationPrototype:object];
}

- (BOOL)isEqualToInvocationPrototype:(MCKInvocationPrototype *)other {
    return (other != nil
            && (self.invocation == other.invocation || [self.invocation isEqual:other.invocation])
            && (self.argumentMatchers == other.argumentMatchers || [self.argumentMatchers isEqual:other.argumentMatchers]));
}

- (NSUInteger)hash {
    return ([self.invocation hash] ^ [self.argumentMatchers hash]);
}

@end
