//
//  MCKAllCollector.m
//  mocka
//
//  Created by Markus Gasser on 8.11.2013.
//  Copyright (c) 2013 konoma GmbH. All rights reserved.
//

#import "MCKAllCollector.h"


@interface MCKAllCollector ()

@property (nonatomic, strong) MCKInvocationRecorder *invocationRecorder;

@end

@implementation MCKAllCollector

- (void)beginCollectingResultsWithInvocationRecorder:(MCKInvocationRecorder *)invocationRecorder {
    self.invocationRecorder = invocationRecorder;
}

- (MCKVerificationResult *)collectVerificationResult:(MCKVerificationResult *)result {
    [self.invocationRecorder removeInvocationsAtIndexes:result.matchingIndexes];
    return result;
}

- (MCKVerificationResult *)finishCollectingResults {
    return nil;
}

@end
