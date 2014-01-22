//
//  NSInputStream+ACOParsing.m
//  ACOKit
//
//  Created by Markus Gasser on 22.01.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

#import "NSInputStream+ACOParsing.h"
#import "ACOParserError.h"


@implementation NSInputStream (ACOParsing)

- (BOOL)aco_readWord:(out uint16_t *)word error:(NSError **)error
{
    NSParameterAssert(word != NULL);
    
    uint16_t buffer;
    if (![self aco_readDataOfSize:sizeof(uint16_t) intoBuffer:&buffer error:error]) {
        return NO;
    }
    
    *word = ntohs(buffer); // ACO files are big-endian (aka network byte order)
    return YES;
}

- (BOOL)aco_readString:(out NSString **)string error:(NSError **)error
{
    NSParameterAssert(string != NULL);
    
    uint32_t length; // length in chars
    if (![self aco_readLength:&length error:error]) {
        return NO;
    }
    
    NSMutableData *data = [NSMutableData dataWithLength:(length * 2)]; // data is stored in UTF-16, so 2 bytes per char
    if (![self aco_readDataOfSize:(length * 2) intoBuffer:data.mutableBytes error:error]) {
        return NO;
    }
    
    *string = [[NSString alloc] initWithData:data encoding:NSUTF16BigEndianStringEncoding];
    return YES;
}

- (BOOL)aco_readLength:(out uint32_t *)length error:(NSError **)error
{
    NSParameterAssert(length != NULL);
    
    uint32_t buffer;
    if (![self aco_readDataOfSize:sizeof(uint32_t) intoBuffer:&buffer error:error]) {
        return NO;
    }
    
    *length = ntohl(buffer); // ACO files are big-endian (aka network byte order)
    return YES;
}

- (BOOL)aco_readDataOfSize:(size_t)size intoBuffer:(void *)buffer error:(NSError **)error;
{
    NSParameterAssert(buffer != NULL);
    
    NSUInteger offset = 0;
    NSUInteger read = NSUIntegerMax;
    
    while (offset < size && read > 0) {
        read = [self read:(buffer + offset) maxLength:(size - offset)];
        if (read == -1) {
            if (error != NULL) { *error = [self streamError]; }
            return NO;
        }
        offset += read;
    }
    
    if (offset < size) {
        if (error != NULL) { *error = [NSError aco_parserErrorWithType:ACOParserErrorUnexpectedEndOfFile]; }
        return NO;
    }
    
    return YES;
}

@end
