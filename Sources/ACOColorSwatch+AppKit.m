//
//  ACOColorSwatch+AppKit.m
//  ACOKit
//
//  Created by Markus Gasser on 22.01.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

#import "ACOColorSwatch+AppKit.h"
#import "ACOColorEntry.h"


@implementation ACOColorSwatch (AppKit)

- (NSColor *)colorAtIndex:(NSUInteger)index
{
    return [NSColor colorWithCGColor:[[self colorEntryAtIndex:index] CGColor]];
}

- (NSColor *)colorForName:(NSString *)name
{
    return [NSColor colorWithCGColor:[[self colorEntryForName:name] CGColor]];
}

- (NSColor *)objectAtIndexedSubscript:(NSUInteger)idx
{
    return [self colorAtIndex:idx];
}

- (NSColor *)objectForKeyedSubscript:(NSString *)key
{
    return [self colorForName:key];
}

@end
