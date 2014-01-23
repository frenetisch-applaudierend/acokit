//
//  ACOKitTests_UIKit.m
//  acokit-tests
//
//  Created by Markus Gasser on 22.01.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <AppKit/AppKit.h>
#import "ACOKit.h"


@interface ACOKitTests_AppKit : XCTestCase @end
@implementation ACOKitTests_AppKit

- (void)testGettingColorsByIndex
{
    NSURL *url = [[NSBundle bundleForClass:self.class] URLForResource:@"RGB_V2" withExtension:@"aco"];
    ACOColorSwatch *colorSwatch = [ACOColorSwatch colorSwatchFromFileAtURL:url error:NULL];
    
    expect(colorSwatch[0]).to.equal([NSColor colorWithDeviceRed:1.0f green:0.0f blue:0.0f alpha:1.0f]);
    expect(colorSwatch[1]).to.equal([NSColor colorWithDeviceRed:0.0f green:1.0f blue:0.0f alpha:1.0f]);
    expect(colorSwatch[2]).to.equal([NSColor colorWithDeviceRed:0.0f green:0.0f blue:1.0f alpha:1.0f]);
}

- (void)testGettingColorsByName
{
    NSURL *url = [[NSBundle bundleForClass:self.class] URLForResource:@"RGB_V2" withExtension:@"aco"];
    ACOColorSwatch *colorSwatch = [ACOColorSwatch colorSwatchFromFileAtURL:url error:NULL];
    
    expect(colorSwatch[@"red"]).to.equal([NSColor colorWithDeviceRed:1.0f green:0.0f blue:0.0f alpha:1.0f]);
    expect(colorSwatch[@"green"]).to.equal([NSColor colorWithDeviceRed:0.0f green:1.0f blue:0.0f alpha:1.0f]);
    expect(colorSwatch[@"blue"]).to.equal([NSColor colorWithDeviceRed:0.0f green:0.0f blue:1.0f alpha:1.0f]);
}

@end
