//
//  MCKDefaultVerificationHandler.m
//  mocka
//
//  Created by Markus Gasser on 14.07.12.
//  Copyright (c) 2012 Markus Gasser. All rights reserved.
//

#import "MCKDefaultVerificationHandler.h"


@implementation MCKDefaultVerificationHandler

#pragma mark - Initializaition

+ (instancetype)defaultHandler {
    static id defaultHandler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultHandler = [[MCKDefaultVerificationHandler alloc] init];
    });
    return defaultHandler;
}


#pragma mark - Matching Invocations

- (MCKVerificationResult *)verifyInvocations:(NSArray *)invocations forPrototype:(MCKInvocationPrototype *)prototype {
    NSIndexSet *indexes = [invocations indexesOfObjectsPassingTest:^BOOL(NSInvocation *invocation, NSUInteger idx, BOOL *stop) {
        return [prototype matchesInvocation:invocation];
    }];
    
    if ([indexes count] > 0) {
        return [MCKVerificationResult successWithMatchingIndexes:[NSIndexSet indexSetWithIndex:[indexes firstIndex]]];
    } else {
        NSString *reason = [NSString stringWithFormat:@"Expected a call to %@ but no such call was made", prototype.methodName];
        return [MCKVerificationResult failureWithReason:reason matchingIndexes:[NSIndexSet indexSet]];
    }
}


#pragma mark - Timeout Handling

- (BOOL)mustAwaitTimeoutForFailure {
    return NO;
}

- (BOOL)failsFastDuringTimeout {
    return NO;
}

@end
