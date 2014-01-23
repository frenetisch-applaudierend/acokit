//
//  MCKSenTestFailureHandler.m
//  mocka
//
//  Created by Markus Gasser on 05.10.12.
//  Copyright (c) 2012 Markus Gasser. All rights reserved.
//

#import "MCKSenTestFailureHandler.h"


@interface NSException (SenTestSupport)

+ (id)failureInFile:(NSString *)file atLine:(int)line withDescription:(NSString *)desc, ...;
- (void)failWithException:(NSException *)ex; // actually it's on SenTestCase, but all we need is a declaration

@end


@implementation MCKSenTestFailureHandler

#pragma mark - Initialization

- (instancetype)initWithTestCase:(id)testCase {
    if ((self = [super init])) {
        _testCase = testCase;
    }
    return self;
}


#pragma mark - Handling Failures

- (void)handleFailureAtLocation:(MCKLocation *)location withReason:(NSString *)reason {
    [self.testCase failWithException:[self exceptionForFile:location.fileName line:location.lineNumber reason:reason]];
}

- (NSException *)exceptionForFile:(NSString *)file line:(NSUInteger)line reason:(NSString *)reason {
    return [NSException failureInFile:file atLine:(int)line withDescription:(reason != nil ? @"%@" : nil), reason];
}

@end
