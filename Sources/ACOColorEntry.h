//
//  ACOColorEntry.h
//  ACOKit
//
//  Created by Markus Gasser on 22.01.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>


/**
 * Supported color spaces for the ACO file format.
 */
typedef NS_ENUM(uint16_t, ACOColorSpace) {
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
    struct { uint16_t cyan, magenta, yellow, key; } CMYK;
    struct { uint16_t lightness, a_chrominance, b_chrominance; } Lab;
    struct { uint16_t grayValue; } Grayscale;
} ACOColorData;

/**
 * Create a color data union for one of the supported color spaces, or using raw data.
 */
extern ACOColorData ACOColorDataWithComponents(uint16_t components[4]);
extern ACOColorData ACOColorDataWithRGB(uint16_t red, uint16_t green, uint16_t blue);
extern ACOColorData ACOColorDataWithHSB(uint16_t hue, uint16_t saturation, uint16_t brightness);
extern ACOColorData ACOColorDataWithCMYK(uint16_t cyan, uint16_t magenta, uint16_t yellow, uint16_t key);
extern ACOColorData ACOColorDataWithLab(uint16_t lightness, uint16_t a_chrominance, uint16_t b_chrominance);
extern ACOColorData ACOColorDataWithGrayscale(uint16_t grayValue);


@interface ACOColorEntry : NSObject

- (instancetype)initWithName:(NSString *)name colorSpace:(ACOColorSpace)colorSpace colorData:(ACOColorData)colorData;

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) ACOColorSpace colorSpace;
@property (nonatomic, readonly) ACOColorData colorData;
@property (nonatomic, readonly) CGColorSpaceRef CGColorSpace;
@property (nonatomic, readonly) CGColorRef CGColor;

@end
