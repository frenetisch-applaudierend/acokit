//
//  MCKExceptionFailureHandler.m
//  mocka
//
//  Created by Markus Gasser on 05.10.12.
//  Copyright (c) 2012 Markus Gasser. All rights reserved.
//

#import "MCKExceptionFailureHandler.h"

NSString * const MCKTestFailureException = @"MCKTestFailureException";
NSString * const MCKFileNameKey = @"fileName";
NSString * const MCKLineNumberKey = @"lineNumber";


@implementation MCKExceptionFailureHandler

#pragma mark - Handling Failures

- (void)handleFailureAtLocation:(MCKLocation *)location withReason:(NSString *)reason {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setValue:location.fileName forKey:MCKFileNameKey];
    [userInfo setValue:@(location.lineNumber) forKey:MCKLineNumberKey];
    @throw [NSException exceptionWithName:MCKTestFailureException reason:reason userInfo:userInfo];
}

@end
