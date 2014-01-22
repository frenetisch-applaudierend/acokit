//
//  ACOParserError.m
//  ACOKit
//
//  Created by Markus Gasser on 22.01.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

#import "ACOParserError.h"


NSString * const ACOParserErrorDomain = @"ACOParserErrorDomain";


@implementation NSError (ACOParserError)

+ (instancetype)aco_parserErrorWithType:(ACOParserError)error
{
    return [[self alloc] initWithDomain:ACOParserErrorDomain code:error userInfo:nil];
}

@end
