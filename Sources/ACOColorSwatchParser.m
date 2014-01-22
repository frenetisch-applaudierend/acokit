//
//  ACOColorSwatchParser.m
//  ACOKit
//
//  Created by Markus Gasser on 22.01.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

#import "ACOColorSwatchParser.h"
#import "ACOColorSwatch.h"
#import "ACOParserError.h"
#import "NSInputStream+ACOParsing.h"


@implementation ACOColorSwatchParser

+ (instancetype)defaultParser
{
    static dispatch_once_t onceToken;
    static ACOColorSwatchParser *parser;
    dispatch_once(&onceToken, ^{
        parser = [[ACOColorSwatchParser alloc] init];
    });
    return parser;
}

- (ACOColorSwatch *)parseColorSwatchFromFileAtURL:(NSURL *)fileURL error:(NSError **)error
{
    NSInputStream *inputStream = [NSInputStream inputStreamWithURL:fileURL];
    [inputStream open];
    return [self parseColorSwatchFromStream:inputStream error:error];
}

- (ACOColorSwatch *)parseColorSwatchFromStream:(NSInputStream *)stream error:(NSError **)error
{
    return [self parseColorSwatchOfVersion:1 fromStream:stream error:error];
}

- (ACOColorSwatch *)parseColorSwatchOfVersion:(NSUInteger)expected fromStream:(NSInputStream *)stream error:(NSError **)error
{
    // read the header
    uint16_t version, count;
    if (![stream aco_readWord:&version error:error] || ![stream aco_readWord:&count error:error]) {
        return nil;
    }
    
    if (version != expected) {
        if (error != NULL) { *error = [NSError aco_parserErrorWithType:ACOParserErrorUnknownVersion]; }
        return nil;
    }
    
    return [[ACOColorSwatch alloc] initWithVersion:version entries:@[]];
}

@end
