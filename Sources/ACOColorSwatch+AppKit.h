//
//  ACOColorSwatch+Cocoa.h
//  ACOKit
//
//  Created by Markus Gasser on 22.01.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

#import "ACOColorSwatch.h"


@interface ACOColorSwatch (AppKit)

- (NSColor *)colorAtIndex:(NSUInteger)index;
- (NSColor *)colorForName:(NSString *)name;

- (NSColor *)objectAtIndexedSubscript:(NSUInteger)idx;
- (NSColor *)objectForKeyedSubscript:(NSString *)key;

@end
