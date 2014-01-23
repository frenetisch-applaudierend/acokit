//
//  MCKFailureHandler.h
//  mocka
//
//  Created by Markus Gasser on 05.10.12.
//  Copyright (c) 2012 Markus Gasser. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MCKLocation.h"


@protocol MCKFailureHandler <NSObject>

- (void)handleFailureAtLocation:(MCKLocation *)location withReason:(NSString *)reason;

@end


@interface MCKFailureHandler : NSObject <MCKFailureHandler>

#pragma mark - Getting a Failure Handler

+ (id<MCKFailureHandler>)failureHandlerForTestCase:(id)testCase;

@end
