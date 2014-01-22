//
//  ACOColorEntry.m
//  ACOKit
//
//  Created by Markus Gasser on 22.01.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

#import "ACOColorEntry.h"


ACOColorData ACOColorDataFromComponents(uint16_t components[4])
{
    ACOColorData colorData;
    memcpy(colorData.components, components, 4 * sizeof(uint16_t));
    return colorData;
}


@implementation ACOColorEntry

#pragma mark - Initialization

- (instancetype)initWithName:(NSString *)name colorSpace:(ACOColorSpace)colorSpace colorData:(ACOColorData)colorData
{
    if ((self = [super init])) {
        _name = [name copy];
        _colorSpace = colorSpace;
        _colorData = colorData;
    }
    return self;
}

@end
