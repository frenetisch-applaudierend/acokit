//
//  ACOColorSwatchParser.m
//  ACOKit
//
//  Created by Markus Gasser on 22.01.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

#import "ACOColorSwatchParser.h"
#import "ACOColorEntryParser.h"
#import "ACOColorSwatch.h"
#import "ACOParserError.h"
#import "NSInputStream+ACOParsing.h"


@implementation ACOColorSwatchParser

#pragma mark - Initialization

+ (instancetype)defaultParser
{
    static dispatch_once_t onceToken;
    static ACOColorSwatchParser *parser;
    dispatch_once(&onceToken, ^{
        parser = [[ACOColorSwatchParser alloc] initWithEntryParser:[[ACOColorEntryParser alloc] init]];
    });
    return parser;
}

- (instancetype)initWithEntryParser:(ACOColorEntryParser *)entryParser
{
    if ((self = [super init])) {
        _entryParser = entryParser;
    }
    return self;
}


#pragma mark - Parsing

- (ACOColorSwatch *)parseColorSwatchFromFileAtURL:(NSURL *)fileURL error:(NSError **)error
{
    NSInputStream *inputStream = [NSInputStream inputStreamWithURL:fileURL];
    [inputStream open];
    return [self parseColorSwatchFromStream:inputStream error:error];
}

- (ACOColorSwatch *)parseColorSwatchFromStream:(NSInputStream *)stream error:(NSError **)error
{
    ACOColorSwatch *version1 = [self parseColorSwatchOfVersion:1 fromStream:stream error:error];
    if (version1 == nil) {
        return nil;
    }
    
    if ([stream hasBytesAvailable]) {
        return [self parseColorSwatchOfVersion:2 fromStream:stream error:error];
    } else {
        return version1;
    }
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
    
    NSMutableArray *entries = [NSMutableArray array];
    for (uint16_t i = 0; i < count; i++) {
        ACOColorEntry *entry = [self.entryParser parseColorEntryWithVersion:version fromStream:stream error:error];
        if (entry == nil) {
            return nil;
        }
        [entries addObject:entry];
    }
    
    return [[ACOColorSwatch alloc] initWithVersion:version entries:entries];
}

@end
