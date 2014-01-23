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

static CGFloat* HSVtoRGB(CGFloat components[])
{
    static const int R = 0, G = 1, B = 2;
    const CGFloat hue = components[0], saturation = components[1], value = components[2];
    
    // check for grey values
    if (saturation == 0.0f) {
        components[R] = components[G] = components[B] = value;
        return components;
    }
    
    // calculate sector and derived values
    const NSUInteger sector = floorf(hue * 5.0f);      // sector from 0 .. 5
    const CGFloat factorial = ((hue * 5.0f) - sector); // factorial part of the sector
    const CGFloat p = (value * (1.0f - saturation));
    const CGFloat q = (value * (1.0f - (saturation * factorial)));
    const CGFloat t = (value * (1.0f - (saturation * (1.0f - factorial))));
    
    // calculate RGB values
    switch (sector) {
        case 0: { components[R] = value; components[G] = t;     components[B] = p;     break; }
        case 1: { components[R] = q;     components[G] = value; components[B] = p;     break; }
        case 2: { components[R] = p;     components[G] = value; components[B] = t;     break; }
        case 3: { components[R] = p;     components[G] = q;     components[B] = value; break; }
        case 4: { components[R] = t;     components[G] = p;     components[B] = value; break; }
        case 5: { components[R] = value; components[G] = p;     components[B] = q;     break; }
            
        default:
            @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Should never reach" userInfo:nil];
    }
    
    return components;
}


@implementation ACOColorEntry

@synthesize CGColorSpace = _CGColorSpace;
@synthesize CGColor = _CGColor;


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


#pragma mark - Generating CGColor Objects

- (CGColorSpaceRef)CGColorSpace
{
    if (_CGColorSpace == NULL) {
        static const CGFloat LabWhitePoint[] = { 10000.0f, 0.0f, 0.0f };
        static const CGFloat LabBlackPoint[] = { 0.0f, 0.0f, 0.0f };
        static const CGFloat LabRange[] = { -12800.0f, 12700.0f, -12800.0f, 12700.0f };
        
        switch (self.colorSpace) {
            case ACOColorSpaceRGB:       _CGColorSpace = CGColorSpaceCreateDeviceRGB(); break;
            case ACOColorSpaceHSB:       _CGColorSpace = CGColorSpaceCreateDeviceRGB(); break; // HSB can be converted to RGB
            case ACOColorSpaceCMYK:      _CGColorSpace = CGColorSpaceCreateDeviceCMYK(); break;
            case ACOColorSpaceLab:       _CGColorSpace = CGColorSpaceCreateLab(LabWhitePoint, LabBlackPoint, LabRange); break;
            case ACOColorSpaceGrayscale: _CGColorSpace = CGColorSpaceCreateDeviceGray(); break;
                
            default:
                @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Unknown color space" userInfo:nil];
        }
    }
    return _CGColorSpace;
}

- (CGColorRef)CGColor
{
    if (_CGColor == NULL) {
        CGFloat components[5] = { 1.0f, 1.0f, 1.0f, 1.0f, 1.0f };
        switch (self.colorSpace) {
            case ACOColorSpaceRGB:       [self fillComponentsForRGB:components]; break;
            case ACOColorSpaceHSB:       [self fillComponentsForHSB:components]; break;
            case ACOColorSpaceCMYK:      [self fillComponentsForCMYK:components]; break;
            case ACOColorSpaceLab:       [self fillComponentsForLab:components]; break;
            case ACOColorSpaceGrayscale: [self fillComponentsForGrayscale:components]; break;
                
            default:
                @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Unknown color space" userInfo:nil];
        }
        _CGColor = CGColorCreate(self.CGColorSpace, components);
    }
    return _CGColor;
}

- (void)fillComponentsForRGB:(CGFloat[])components
{
    // The first three values in the color data are red, green, and blue.
    // They are full unsigned 16-bit values as in Apple's RGBColor data structure. Pure red = 65535, 0, 0.
    
    components[0] = (self.colorData.components[0] / 65535.0f);
    components[1] = (self.colorData.components[1] / 65535.0f);
    components[2] = (self.colorData.components[2] / 65535.0f);
}

- (void)fillComponentsForHSB:(CGFloat[])components
{
    // The first three values in the color data are hue, saturation, and brightness.
    // They are full unsigned 16-bit values as in Apple's HSVColor data structure. Pure red = 0,65535, 65535.
    //
    // NOTE: HSB color space is not supported, therefore we convert to RGB first
    //       see http://en.wikipedia.org/wiki/HSL_and_HSV
    
    components[0] = (self.colorData.components[0] / 65535.0f);
    components[1] = (self.colorData.components[1] / 65535.0f);
    components[2] = (self.colorData.components[2] / 65535.0f);
    
    components = HSVtoRGB(components);
}

- (void)fillComponentsForCMYK:(CGFloat[])components
{
    // The four values in the color data are cyan, magenta, yellow, and black. They are full unsigned 16-bit values.
    // 0 = 100% ink. For example, pure cyan = 0,65535,65535,65535.
    //
    // NOTE: CGColor expects 1.0f == 100% ink
    
    components[0] = (1.0f - (self.colorData.components[0] / 65535.0f));
    components[1] = (1.0f - (self.colorData.components[1] / 65535.0f));
    components[2] = (1.0f - (self.colorData.components[2] / 65535.0f));
    components[3] = (1.0f - (self.colorData.components[3] / 65535.0f));
}

- (void)fillComponentsForLab:(CGFloat[])components
{
    // The first three values in the color data are lightness, a chrominance, and b chrominance.
    // Lightness is a 16-bit value from 0...10000. Chrominance components are each 16-bit values
    // from -12800...12700. Gray values are represented by chrominance components of 0. Pure white = 10000,0,0.
    //
    // NOTE: the lab color space is adjusted to the values described above
    
    components[0] = (CGFloat)((int16_t)self.colorData.components[0]);
    components[1] = (CGFloat)((int16_t)self.colorData.components[1]);
    components[2] = (CGFloat)((int16_t)self.colorData.components[2]);
}

- (void)fillComponentsForGrayscale:(CGFloat[])components
{
    // The first value in the color data is the gray value, from 0...10000.
    
    components[0] = (CGFloat)(self.colorData.components[0] / 10000.0f);
}

@end
