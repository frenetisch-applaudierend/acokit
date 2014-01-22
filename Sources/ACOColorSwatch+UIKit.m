//
//  ACOColorSwatch+UIKit.m
//  ACOKit
//
//  Created by Markus Gasser on 22.01.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

#import "ACOColorSwatch+UIKit.h"


@implementation ACOColorSwatch (UIKit)

- (UIColor *)colorAtIndex:(NSUInteger)index
{
    return nil;
}

- (UIColor *)colorForName:(NSString *)name
{
    return nil;
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
