//
//  ACOKitTests_UIKit.m
//  acokit-tests
//
//  Created by Markus Gasser on 22.01.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <UIKit/UIKit.h>
#import "ACOKit.h"


@interface ACOKitTests : XCTestCase @end
@implementation ACOKitTests

- (void)testGettingColorsByIndex
{
    NSURL *url = [[NSBundle bundleForClass:self.class] URLForResource:@"RGB_V2" withExtension:@"aco"];
    ACOColorSwatch *colorSwatch = [ACOColorSwatch colorSwatchFromFileAtURL:url error:NULL];
    
    expect(colorSwatch[0]).to.equal([UIColor redColor]);
    expect(colorSwatch[1]).to.equal([UIColor greenColor]);
    expect(colorSwatch[2]).to.equal([UIColor blueColor]);
}

- (void)testGettingColorsByName
{
    NSURL *url = [[NSBundle bundleForClass:self.class] URLForResource:@"RGB_V2" withExtension:@"aco"];
    ACOColorSwatch *colorSwatch = [ACOColorSwatch colorSwatchFromFileAtURL:url error:NULL];
    
    expect(colorSwatch[@"red"]).to.equal([UIColor redColor]);
    expect(colorSwatch[@"green"]).to.equal([UIColor greenColor]);
    expect(colorSwatch[@"blue"]).to.equal([UIColor blueColor]);
}

@end
