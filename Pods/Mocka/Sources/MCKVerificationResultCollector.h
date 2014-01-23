//
//  MCKVerificationResultCollector.h
//  mocka
//
//  Created by Markus Gasser on 30.9.2013.
//  Copyright (c) 2013 konoma GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MCKVerificationResult.h"
#import "MCKInvocationRecorder.h"
#import "MCKVerificationSyntax.h"


@protocol MCKVerificationResultCollector <NSObject>

- (void)beginCollectingResultsWithInvocationRecorder:(MCKInvocationRecorder *)invocationRecorder;
- (MCKVerificationResult *)collectVerificationResult:(MCKVerificationResult *)result;
- (MCKVerificationResult *)finishCollectingResults;

@end
