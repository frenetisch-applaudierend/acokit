//
//  MCKNeverVerificationHandler.m
//  mocka
//
//  Created by Markus Gasser on 22.07.12.
//  Copyright (c) 2012 Markus Gasser. All rights reserved.
//

#import "MCKNeverVerificationHandler.h"


@implementation MCKNeverVerificationHandler

#pragma mark - Initialization

+ (instancetype)neverHandler {
    return [[self alloc] init];
}


#pragma mark - Verifying Invocations

- (MCKVerificationResult *)verifyInvocations:(NSArray *)invocations forPrototype:(MCKInvocationPrototype *)prototype {
    NSIndexSet *indexes = [invocations indexesOfObjectsPassingTest:^BOOL(NSInvocation *invocation, NSUInteger idx, BOOL *stop) {
        return [prototype matchesInvocation:invocation];
    }];
    
    if ([indexes count] == 0) {
        return [MCKVerificationResult successWithMatchingIndexes:[NSIndexSet indexSet]];
    } else {
        NSString *reason = [NSString stringWithFormat:@"Expected no calls to %@ but got %ld",
                            prototype.methodName, (unsigned long)[indexes count]];
        return [MCKVerificationResult failureWithReason:reason matchingIndexes:[NSIndexSet indexSet]];
    }
}


#pragma mark - Timeout Handling

- (BOOL)mustAwaitTimeoutForFailure {
    return YES;
}

- (BOOL)failsFastDuringTimeout {
    return YES;
}

@end
