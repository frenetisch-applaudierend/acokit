//
//  ACOColorEntry.m
//  ACOKit
//
//  Created by Markus Gasser on 22.01.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

#import "ACOColorEntry.h"


ACOColorData ACOColorDataWithComponents(uint16_t components[4])
{
    ACOColorData colorData;
    memcpy(colorData.components, components, 4 * sizeof(uint16_t));
    return colorData;
}

ACOColorData ACOColorDataWithRGB(uint16_t red, uint16_t green, uint16_t blue)
{
    return ACOColorDataWithComponents((uint16_t[]) { red, green, blue, 0 });
}

ACOColorData ACOColorDataWithHSB(uint16_t hue, uint16_t saturation, uint16_t brightness)
{
    return ACOColorDataWithComponents((uint16_t[]) { hue, saturation, brightness, 0 });
}

ACOColorData ACOColorDataWithCMYK(uint16_t cyan, uint16_t magenta, uint16_t yellow, uint16_t key)
{
    return ACOColorDataWithComponents((uint16_t[]) { cyan, magenta, yellow, key });
}

ACOColorData ACOColorDataWithLab(uint16_t lightness, uint16_t a_chrominance, uint16_t b_chrominance)
{
    return ACOColorDataWithComponents((uint16_t[]) { lightness, a_chrominance, b_chrominance, 0 });
}

ACOColorData ACOColorDataWithGrayscale(uint16_t grayValue)
{
    return ACOColorDataWithComponents((uint16_t[]) { grayValue, 0, 0, 0 });
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
