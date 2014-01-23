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
 *
 * Other values are possible, but can't really be used
 * because the color format is proprietary.
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
 *
 * Supports reading/writing either raw color data or fields specific
 * to the supported color spaces.
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


/**
 * An entry in a color swatch file.
 *
 * Consists of color space, color data and an optional name (version 2 files only).
 * An entry can generate CGColorSpaceRef/CGColorRef objects from its data.
 */
@interface ACOColorEntry : NSObject

/**
 * Initialize an entry with a name, color space and color data.
 *
 * @param name The name for this color entry (only in version 2 files)
 * @param colorSpace The color space identifier for this entry. You can also pass an
 *                   unsupported/unknown type, but the CGColor/CGColorSpace are not
 *                   supported in this case and will throw an exception.
 * @param colorData  The color data for the specified color space
 *
 * @return An initialized ACOColorEntry object.
 */
- (instancetype)initWithName:(NSString *)name colorSpace:(ACOColorSpace)colorSpace colorData:(ACOColorData)colorData;

@property (nonatomic, readonly) NSString *name;               /// The name for this color (version 2 only)
@property (nonatomic, readonly) ACOColorSpace colorSpace;     /// The color space type
@property (nonatomic, readonly) ACOColorData colorData;       /// The color data
@property (nonatomic, readonly) CGColorSpaceRef CGColorSpace; /// The CGColorSpaceRef matching the type in colorSpace
@property (nonatomic, readonly) CGColorRef CGColor;           /// The CGColorRef created from the color space and color data

@end
