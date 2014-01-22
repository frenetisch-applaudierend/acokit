//
//  ACOColorEntry.h
//  ACOKit
//
//  Created by Markus Gasser on 22.01.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 * Supported color spaces for the ACO file format.
 */
typedef NS_ENUM(NSUInteger, ACOColorSpace) {
    ACOColorSpaceRGB       = 0,
    ACOColorSpaceHSB       = 1,
    ACOColorSpaceCMYK      = 2,
    ACOColorSpaceLab       = 7,
    ACOColorSpaceGrayscale = 8,
};

/**
 * Color data structure.
 */
#pragma pack(2)
typedef union {
    uint16_t components[4];
    struct { uint16_t red, green, blue; } RGB;
    struct { uint16_t hue, saturation, brightness; } HSB;
    struct { uint16_t cyan, magenta, yellow, black; } CMYK;
    struct { uint16_t lightness, a_chrominance, b_chrominance; } Lab;
    struct { uint16_t grayValue; } Grayscale;
} ACOColorData;

/**
 * Create a color data union from the given raw components.
 */
extern ACOColorData ACOColorDataFromComponents(uint16_t components[4]);


@interface ACOColorEntry : NSObject

- (instancetype)initWithName:(NSString *)name colorSpace:(ACOColorSpace)colorSpace colorData:(ACOColorData)colorData;

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) ACOColorSpace colorSpace;
@property (nonatomic, readonly) ACOColorData colorData;

@end
