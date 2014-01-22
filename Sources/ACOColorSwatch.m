//
//  ACOColorSwatch.m
//  ACOKit
//
//  Created by Markus Gasser on 22.01.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

#import "ACOColorSwatch.h"
#import "ACOColorEntry.h"
#import "ACOColorSwatchParser.h"


@implementation ACOColorSwatch

#pragma mark - Initialization

+ (instancetype)colorSwatchFromFileAtURL:(NSURL *)url error:(NSError **)error
{
    return [[ACOColorSwatchParser defaultParser] parseColorSwatchFromFileAtURL:url error:error];
}

- (instancetype)initWithVersion:(NSUInteger)version entries:(NSArray *)entries
{
    if ((self = [super init])) {
        _version = version;
        _entries = [entries copy];
    }
    return self;
}


#pragma mark - Getting Color Entries

- (ACOColorEntry *)colorEntryAtIndex:(NSUInteger)index
{
    return self.entries[index];
}

- (ACOColorEntry *)colorEntryForName:(NSString *)name
{
    NSParameterAssert(name != nil);
    
    for (ACOColorEntry *entry in self.entries) {
        if ([entry.name isEqualToString:name]) {
            return entry;
        }
    }
    return nil;
}

@end
