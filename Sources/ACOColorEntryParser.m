//
//  ACOColorEntryParser.m
//  ACOKit
//
//  Created by Markus Gasser on 22.01.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

#import "ACOColorEntryParser.h"
#import "ACOColorEntry.h"
#import "NSInputStream+ACOParsing.h"


@implementation ACOColorEntryParser

- (ACOColorEntry *)parseColorEntryWithVersion:(NSUInteger)version fromStream:(NSInputStream *)stream error:(NSError **)error
{
    ACOColorSpace colorSpace;
    ACOColorData colorData;
    NSString *name = nil;
    
    if (   ![stream aco_readWord:&colorSpace error:error]
        || ![stream aco_readWord:&(colorData.components[0]) error:error]
        || ![stream aco_readWord:&(colorData.components[1]) error:error]
        || ![stream aco_readWord:&(colorData.components[2]) error:error]
        || ![stream aco_readWord:&(colorData.components[3]) error:error])
    {
        return nil;
    }
    
    if (version == 2 && ![stream aco_readString:&name error:error]) {
        return nil;
    }
    
    return [[ACOColorEntry alloc] initWithName:name colorSpace:colorSpace colorData:colorData];
}

@end
