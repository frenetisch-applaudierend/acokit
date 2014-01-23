//
//  ACOColorEntryTest.m
//  ACOKit
//
//  Created by Markus Gasser on 23/01/14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <CoreGraphics/CoreGraphics.h>
#import "ACOColorEntry.h"


@interface ACOColorEntryTest : XCTestCase @end
@implementation ACOColorEntryTest

#pragma mark - Test Creating Color Spaces

- (void)testThatRGBColorSpaceIsCreated
{
    ACOColorEntry *entry = [[ACOColorEntry alloc] initWithName:nil colorSpace:ACOColorSpaceRGB colorData:(ACOColorData){}];
    expect(CGColorSpaceGetModel(entry.CGColorSpace)).to.equal(kCGColorSpaceModelRGB);
}

- (void)testThatHSBColorSpaceIsCreatedAsRGB
{
    ACOColorEntry *entry = [[ACOColorEntry alloc] initWithName:nil colorSpace:ACOColorSpaceHSB colorData:(ACOColorData){}];
    expect(CGColorSpaceGetModel(entry.CGColorSpace)).to.equal(kCGColorSpaceModelRGB);
}

- (void)testThatCMYKColorSpaceIsCreated
{
    ACOColorEntry *entry = [[ACOColorEntry alloc] initWithName:nil colorSpace:ACOColorSpaceCMYK colorData:(ACOColorData){}];
    expect(CGColorSpaceGetModel(entry.CGColorSpace)).to.equal(kCGColorSpaceModelCMYK);
}

- (void)testThatLabColorSpaceIsCreated
{
    ACOColorEntry *entry = [[ACOColorEntry alloc] initWithName:nil colorSpace:ACOColorSpaceLab colorData:(ACOColorData){}];
    expect(CGColorSpaceGetModel(entry.CGColorSpace)).to.equal(kCGColorSpaceModelLab);
}

- (void)testThatGrayscaleColorSpaceIsCreated
{
    ACOColorEntry *entry = [[ACOColorEntry alloc] initWithName:nil colorSpace:ACOColorSpaceGrayscale colorData:(ACOColorData){}];
    expect(CGColorSpaceGetModel(entry.CGColorSpace)).to.equal(kCGColorSpaceModelMonochrome);
}


#pragma mark - Test Creating Colors

- (void)testThatRGBColorIsCreated
{
    ACOColorEntry *entry = [[ACOColorEntry alloc] initWithName:nil colorSpace:ACOColorSpaceRGB colorData:ACOColorDataWithRGB(0xFFFF, 0x8000, 0x0000)];
    const CGFloat *components = CGColorGetComponents(entry.CGColor);
    
    expect(components[0]).to.equal(1.0f);
    expect(components[1]).to.beCloseToWithin(0.5f, 0.00001f);
    expect(components[2]).to.equal(0.0f);
    expect(components[3]).to.equal(1.0f); // alpha
}

- (void)testThatHSBColorIsCreatedAsRGB
{
    ACOColorEntry *entry = [[ACOColorEntry alloc] initWithName:nil colorSpace:ACOColorSpaceHSB colorData:ACOColorDataWithHSB(0, 65535, 65535)];
    const CGFloat *components = CGColorGetComponents(entry.CGColor);
    
    expect(components[0]).to.equal(1.0f);
    expect(components[1]).to.equal(0.0f);
    expect(components[2]).to.equal(0.0f);
    expect(components[3]).to.equal(1.0f); // alpha
}

- (void)testThatCMYKColorIsCreated
{
    ACOColorEntry *entry = [[ACOColorEntry alloc] initWithName:nil colorSpace:ACOColorSpaceCMYK colorData:ACOColorDataWithCMYK(0, 65535, 65535, 65535)];
    const CGFloat *components = CGColorGetComponents(entry.CGColor);
    
    expect(components[0]).to.equal(1.0f);
    expect(components[1]).to.equal(0.0f);
    expect(components[2]).to.equal(0.0f);
    expect(components[3]).to.equal(0.0f);
    expect(components[4]).to.equal(1.0f); // alpha
}

//- (void)testThatLabColorIsCreated
//{
//    ACOColorEntry *entry = [[ACOColorEntry alloc] initWithName:nil colorSpace:ACOColorSpaceLab colorData:ACOColorDataWithLab(10000, 0, 0)];
//    const CGFloat *components = CGColorGetComponents(entry.CGColor);
//    
//    expect(components[0]).to.equal(1.0f);
//    expect(components[1]).to.equal(0.5f);
//    expect(components[2]).to.equal(0.5f);
//    expect(components[3]).to.equal(1.0f); // alpha
//}

- (void)testThatGrayscaleColorIsCreated
{
    ACOColorEntry *entry = [[ACOColorEntry alloc] initWithName:nil colorSpace:ACOColorSpaceGrayscale colorData:ACOColorDataWithGrayscale(5000)];
    const CGFloat *components = CGColorGetComponents(entry.CGColor);
    
    expect(components[0]).to.equal(0.5f);
    expect(components[1]).to.equal(1.0f); // alpha
}

@end
