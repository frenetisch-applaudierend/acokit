//
//  MCKXCTestFailureHandler.m
//  mocka
//
//  Created by Markus Gasser on 27.9.2013.
//
//

#import "MCKXCTestFailureHandler.h"


@implementation MCKXCTestFailureHandler

#pragma mark - Initialization

- (instancetype)initWithTestCase:(id)testCase {
    if ((self = [super init])) {
        _testCase = testCase;
    }
    return self;
}


#pragma mark - Handling Failures

- (void)handleFailureAtLocation:(MCKLocation *)location withReason:(NSString *)reason {
    [self.testCase recordFailureWithDescription:reason inFile:location.fileName atLine:location.lineNumber expected:NO];
}

- (void)recordFailureWithDescription:(NSString *)d inFile:(NSString *)f atLine:(NSUInteger)l expected:(BOOL)e {
    // only needed to provide selector for test failure method
}

@end
