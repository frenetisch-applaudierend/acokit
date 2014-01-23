//
//  ACOColorSwatchParserTest.m
//  ACOKit
//
//  Created by Markus Gasser on 22.01.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ACOColorSwatchParser.h"
#import "ACOColorEntryParser.h"
#import "ACOColorSwatch.h"
#import "ACOColorEntry.h"
#import "SwatchDataGenerator.h"


@interface ACOColorSwatchParserTest : XCTestCase @end
@implementation ACOColorSwatchParserTest {
    ACOColorSwatchParser *parser;
    ACOColorEntry *dummyEntry;
}

#pragma mark - Setup

- (void)setUp
{
    dummyEntry = [[ACOColorEntry alloc] init];
    parser = [[ACOColorSwatchParser alloc] initWithEntryParser:mockForClass(ACOColorEntryParser)];
    stub ([parser.entryParser parseColorEntryWithVersion:anyInt() fromStream:anyObject() error:anyObjectPointer(__autoreleasing)]) with {
        return dummyEntry;
    };
}


#pragma mark - Test Header Parsing

- (void)testThatMinimalFileIsParsedCorrectly {
    // given
    NSInputStream *fileStream = [NSInputStream inputStreamWithData:DataForHeader(1, 0)];
    [fileStream open];
    
    // when
    NSError *error = nil;
    ACOColorSwatch *colorSwatch = [parser parseColorSwatchFromStream:fileStream error:&error];
    
    // then
    expect(colorSwatch).notTo.beNil();
    expect(colorSwatch.version).to.equal(1);
    expect(colorSwatch.entries).to.equal(@[]);
}

- (void)testThatFileWithVersion2ContentIsReportedAsVersion2
{
    // given
    NSMutableData *fileData = [NSMutableData data];
    [fileData appendData:DataForHeader(1, 0)];
    [fileData appendData:DataForHeader(2, 0)];
    
    NSInputStream *fileStream = [NSInputStream inputStreamWithData:fileData];
    [fileStream open];
    
    // when
    NSError *error = nil;
    ACOColorSwatch *colorSwatch = [parser parseColorSwatchFromStream:fileStream error:&error];
    
    // then
    expect(colorSwatch).notTo.beNil();
    expect(colorSwatch.version).to.equal(2);
    expect(colorSwatch.entries).to.equal(@[]);
}


#pragma mark - Test Entry Parsing

- (void)testThatVersion1EntriesAreParsed
{
    // given
    NSMutableData *fileData = [NSMutableData data];
    [fileData appendData:DataForHeader(1, 3)];
    [fileData appendData:DataForV1Entry(ACOColorSpaceRGB, ACOColorDataWithRGB(0xFFFF, 0x0000, 0x0000))];
    [fileData appendData:DataForV1Entry(ACOColorSpaceRGB, ACOColorDataWithRGB(0x0000, 0xFFFF, 0x0000))];
    [fileData appendData:DataForV1Entry(ACOColorSpaceRGB, ACOColorDataWithRGB(0x0000, 0x0000, 0xFFFF))];
    
    NSInputStream *fileStream = [NSInputStream inputStreamWithData:fileData];
    [fileStream open];
    
    // when
    [parser parseColorSwatchFromStream:fileStream error:NULL];
    
    // then
    verifyCall (exactly(3) [parser.entryParser parseColorEntryWithVersion:intArg(1) fromStream:fileStream error:anyObjectPointer(__autoreleasing)]);
}

@end
