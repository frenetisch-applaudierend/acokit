//
//  ACOParserError.h
//  ACOKit
//
//  Created by Markus Gasser on 22.01.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSString * const ACOParserErrorDomain;

typedef NS_ENUM(NSUInteger, ACOParserError) {
    ACOParserErrorUnexpectedEndOfFile = 1,
    ACOParserErrorUnknownVersion = 2,
};


@interface NSError (ACOParserError)

+ (instancetype)aco_parserErrorWithType:(ACOParserError)error;

@end
