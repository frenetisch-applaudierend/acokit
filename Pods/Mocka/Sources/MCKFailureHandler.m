//
//  MCKFailureHandler.m
//  mocka
//
//  Created by Markus Gasser on 16.11.12.
//  Copyright (c) 2012 Markus Gasser. All rights reserved.
//

#import "MCKFailureHandler.h"
#import "MCKSenTestFailureHandler.h"
#import "MCKXCTestFailureHandler.h"
#import "MCKExceptionFailureHandler.h"


@implementation MCKFailureHandler

#pragma mark - Getting a Failure Handler

+ (id<MCKFailureHandler>)failureHandlerForTestCase:(id)testCase {
    if ([testCase isKindOfClass:NSClassFromString(@"SenTestCase")]) {
        return [[MCKSenTestFailureHandler alloc] initWithTestCase:testCase];
    } else if ([testCase isKindOfClass:NSClassFromString(@"XCTestCase")]) {
        return [[MCKXCTestFailureHandler alloc] initWithTestCase:testCase];
    } else {
        return [[MCKExceptionFailureHandler alloc] init];
    }
}


#pragma mark - Handling Failures

- (void)handleFailureAtLocation:(MCKLocation *)location withReason:(NSString *)reason {
}

@end
