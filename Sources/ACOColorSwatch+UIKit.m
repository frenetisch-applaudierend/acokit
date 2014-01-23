//
//  ACOColorSwatch+UIKit.m
//  ACOKit
//
//  Created by Markus Gasser on 22.01.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

#import "ACOColorSwatch+UIKit.h"
#import "ACOColorEntry.h"


@implementation ACOColorSwatch (UIKit)

- (UIColor *)colorAtIndex:(NSUInteger)index
{
    return [UIColor colorWithCGColor:[[self colorEntryAtIndex:index] CGColor]];
}

- (UIColor *)colorForName:(NSString *)name
{
    return [UIColor colorWithCGColor:[[self colorEntryForName:name] CGColor]];
}

- (UIColor *)objectAtIndexedSubscript:(NSUInteger)idx
{
    return [self colorAtIndex:idx];
}

- (UIColor *)objectForKeyedSubscript:(NSString *)key
{
    return [self colorForName:key];
}

@end
