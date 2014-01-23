//
//  SwatchDataGenerator.m
//  ACOKit
//
//  Created by Markus Gasser on 23/01/14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

#import "SwatchDataGenerator.h"


NSData* DataForHeader(NSUInteger version, NSUInteger count)
{
    return [NSData dataWithBytes:(int16_t[]){ htons(version), htons(count) } length:4];
}

NSData* DataForV1Entry(ACOColorSpace colorSpace, ACOColorData data)
{
    return [NSData dataWithBytes:(uint16_t[]) {
        htons((uint16_t)colorSpace),
        htons(data.components[0]),
        htons(data.components[1]),
        htons(data.components[2]),
        htons(data.components[3])
    } length:10];
}

NSData* DataForV2Entry(ACOColorSpace colorSpace, ACOColorData data, NSString *name)
{
    NSMutableData *entryData = [DataForV1Entry(colorSpace, data) mutableCopy];
    [entryData appendBytes:&(uint32_t){ htonl(name.length) } length:4];
    [entryData appendData:[name dataUsingEncoding:NSUTF16BigEndianStringEncoding]];
    return entryData;
}
