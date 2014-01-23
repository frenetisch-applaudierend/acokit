//
//  ACOColorSwatchTest.m
//  ACOKit
//
//  Created by Markus Gasser on 22.01.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ACOColorSwatch.h"
#import "ACOColorEntry.h"



@interface ACOColorSwatchTest : XCTestCase @end
@implementation ACOColorSwatchTest {
    ACOColorData blankColorData;
    NSArray *sampleColorEntries;
}


#pragma mark - Setup

- (void)setUp
{
    blankColorData = ACOColorDataWithComponents((uint16_t[]){ 0.0f, 0.0f, 0.0f, 0.0f });
    sampleColorEntries = @[
        [[ACOColorEntry alloc] initWithName:@"color0" colorSpace:ACOColorSpaceRGB colorData:blankColorData],
        [[ACOColorEntry alloc] initWithName:@"color1" colorSpace:ACOColorSpaceRGB colorData:blankColorData],
        [[ACOColorEntry alloc] initWithName:@"color2" colorSpace:ACOColorSpaceRGB colorData:blankColorData]
    ];
}


#pragma mark - Test Getting Color Entries

- (void)testThatGettingEntryAtIndexReturnsCorrectEntry
{
    // given
    ACOColorSwatch *colorSwatch = [[ACOColorSwatch alloc] initWithVersion:1 entries:sampleColorEntries];
    
    // then
    expect([colorSwatch colorEntryAtIndex:0]).to.beIdenticalTo(sampleColorEntries[0]);
    expect([colorSwatch colorEntryAtIndex:1]).to.beIdenticalTo(sampleColorEntries[1]);
    expect([colorSwatch colorEntryAtIndex:2]).to.beIdenticalTo(sampleColorEntries[2]);
}

- (void)testThatGettingEntryForNameReturnsCorrectEntry
{
    // given
    ACOColorSwatch *colorSwatch = [[ACOColorSwatch alloc] initWithVersion:1 entries:sampleColorEntries];
    
    // then
    expect([colorSwatch colorEntryForName:@"color0"]).to.beIdenticalTo(sampleColorEntries[0]);
    expect([colorSwatch colorEntryForName:@"color1"]).to.beIdenticalTo(sampleColorEntries[1]);
    expect([colorSwatch colorEntryForName:@"color2"]).to.beIdenticalTo(sampleColorEntries[2]);
}

@end
