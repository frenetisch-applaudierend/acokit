//
//  ACOColorSwatchParserTest.m
//  ACOKit
//
//  Created by Markus Gasser on 22.01.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ACOColorSwatchParser.h"
#import "ACOColorSwatch.h"


@interface ACOColorSwatchParserTest : XCTestCase @end
@implementation ACOColorSwatchParserTest {
    ACOColorSwatchParser *parser;
}

#pragma mark - Setup

- (void)setUp
{
    parser = [[ACOColorSwatchParser alloc] init];
}

- (void)testThatMinimalFileIsParsedCorrectly {
    // given
    // minimal file consists only of header: version=1, count=0 (each 16bit, big endian ints)
    NSMutableData *fileData = [NSMutableData dataWithBytes:(int16_t[]){ htons(1), htons(0) } length:4];
    NSInputStream *fileStream = [NSInputStream inputStreamWithData:fileData];
    [fileStream open];
    
    // when
    NSError *error = nil;
    ACOColorSwatch *colorSwatch = [parser parseColorSwatchFromStream:fileStream error:&error];
    
    // then
    expect(colorSwatch).notTo.beNil();
    expect(colorSwatch.version).to.equal(1);
    expect(colorSwatch.entries).to.equal(@[]);
}

@end
