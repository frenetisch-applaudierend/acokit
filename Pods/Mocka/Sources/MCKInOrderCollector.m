//
//  MCKInOrderCollector.m
//  mocka
//
//  Created by Markus Gasser on 30.9.2013.
//  Copyright (c) 2013 konoma GmbH. All rights reserved.
//

#import "MCKInOrderCollector.h"


@interface MCKInOrderCollector ()

@property (nonatomic, strong) MCKInvocationRecorder *invocationRecorder;
@property (nonatomic, strong) NSMutableArray *skippedInvocations;

@end


@implementation MCKInOrderCollector

#pragma mark - Collecting and Processing Results

- (void)beginCollectingResultsWithInvocationRecorder:(MCKInvocationRecorder *)invocationRecorder {
    self.invocationRecorder = invocationRecorder;
    self.skippedInvocations = [NSMutableArray array];
}

- (MCKVerificationResult *)collectVerificationResult:(MCKVerificationResult *)result {
    if ([result.matchingIndexes count] > 0) {
        NSRange totalRange = NSMakeRange(0, ([result.matchingIndexes lastIndex] + 1));
        
        // record skipped invocations so we can add them later
        for (NSUInteger index = 0; index < totalRange.length; index++) {
            if (![result.matchingIndexes containsIndex:index]) {
                [self.skippedInvocations addObject:[self.invocationRecorder invocationAtIndex:index]];
            }
        }
        
        // remove all invocations up to the last matched, so the next call must
        // start verification *after* the last match (thus ensuring the order)
        [self.invocationRecorder removeInvocationsInRange:totalRange];
    }
    return result;
}

- (MCKVerificationResult *)finishCollectingResults {
    [self.invocationRecorder insertInvocations:self.skippedInvocations atIndex:0];
    self.invocationRecorder = nil;
    self.skippedInvocations = nil;
    return nil;
}

@end
