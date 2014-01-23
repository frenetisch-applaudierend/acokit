//
//  ACOColorEntryParserTest.m
//  ACOKit
//
//  Created by Markus Gasser on 23/01/14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ACOColorEntryParser.h"
#import "ACOColorEntry.h"
#import "NSInputStream+ACOParsing.h"
#import "SwatchDataGenerator.h"


@interface ACOColorEntryParserTest : XCTestCase @end
@implementation ACOColorEntryParserTest {
    ACOColorEntryParser *parser;
}

#pragma mark - Setup

- (void)setUp
{
    parser = [[ACOColorEntryParser alloc] init];
}


#pragma mark - Test Parsing V1 Values

- (void)testThatParsingVersion1EntryReturnsEntry
{
    // given
    NSInputStream *entryStream = [NSInputStream inputStreamWithData:DataForV1Entry(ACOColorSpaceRGB, ACOColorDataWithRGB(0xFFFF, 0x0000, 0x0000))];
    [entryStream open];
    
    // when
    ACOColorEntry *entry = [parser parseColorEntryWithVersion:1 fromStream:entryStream error:NULL];
    
    // then
    expect(entry).notTo.beNil();
    expect(entry.name).to.beNil();
    expect(entry.colorSpace).to.equal(ACOColorSpaceRGB);
    expect(entry.colorData.RGB.red).to.equal(0xFFFF);
    expect(entry.colorData.RGB.green).to.equal(0x0000);
    expect(entry.colorData.RGB.blue).to.equal(0x0000);
}

- (void)testThatParsingVersion1EntryReadsOnlyEntryData
{
    // given
    NSMutableData *data = [NSMutableData data];
    [data appendData:DataForV1Entry(ACOColorSpaceRGB, ACOColorDataWithRGB(0xFFFF, 0x0000, 0x0000))]; // entry data
    [data appendBytes:&(uint16_t) { htons(0xAFFE) } length:2]; // marker
    NSInputStream *entryStream = [NSInputStream inputStreamWithData:data];
    [entryStream open];
    
    // when
    [parser parseColorEntryWithVersion:1 fromStream:entryStream error:NULL];
    
    // then
    __block uint16_t marker;
    expect([entryStream aco_readWord:&marker error:NULL]).to.beTruthy();
    expect(marker).to.equal(0xAFFE);
}


#pragma mark - Test Parsing V2 Values

- (void)testThatParsingVersion2EntryReturnsEntry
{
    // given
    NSInputStream *entryStream = [NSInputStream inputStreamWithData:DataForV2Entry(ACOColorSpaceRGB, ACOColorDataWithRGB(0xFFFF, 0x0000, 0x0000), @"red")];
    [entryStream open];
    
    // when
    ACOColorEntry *entry = [parser parseColorEntryWithVersion:2 fromStream:entryStream error:NULL];
    
    // then
    expect(entry).notTo.beNil();
    expect(entry.name).to.equal(@"red");
    expect(entry.colorSpace).to.equal(ACOColorSpaceRGB);
    expect(entry.colorData.RGB.red).to.equal(0xFFFF);
    expect(entry.colorData.RGB.green).to.equal(0x0000);
    expect(entry.colorData.RGB.blue).to.equal(0x0000);
}

- (void)testThatParsingVersion2EntryReadsOnlyEntryData
{
    // given
    NSMutableData *data = [NSMutableData data];
    [data appendData:DataForV2Entry(ACOColorSpaceRGB, ACOColorDataWithRGB(0xFFFF, 0x0000, 0x0000), @"red")]; // entry data
    [data appendBytes:&(uint16_t) { htons(0xAFFE) } length:2]; // marker
    NSInputStream *entryStream = [NSInputStream inputStreamWithData:data];
    [entryStream open];
    
    // when
    [parser parseColorEntryWithVersion:2 fromStream:entryStream error:NULL];
    
    // then
    __block uint16_t marker;
    expect([entryStream aco_readWord:&marker error:NULL]).to.beTruthy();
    expect(marker).to.equal(0xAFFE);
}

@end
