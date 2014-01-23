//
//  ACOColorSwatch.h
//  ACOKit
//
//  Created by Markus Gasser on 22.01.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>


@class ACOColorEntry;


/**
 * A list of (possibly named) colors, loaded from an Adobe Color Swatch file (.aco).
 */
@interface ACOColorSwatch : NSObject

/**
 * Load a color swatch from an URL pointing to a file.
 *
 * @param url   The URL to load the file from
 * @param error An optional error object where any parse errors are reported
 *
 * @return An instance of ACOColorSwatch filled from the specified file
 */
+ (instancetype)colorSwatchFromFileAtURL:(NSURL *)url error:(NSError **)error;

/**
 * Initialize a color swatch with the specified version and color entries.
 *
 * @param version The version of the aco file that was loaded. The parser supports versions 1 and 2
 * @param entries An array of ACOColorEntry objects which represent the colors in this swatch
 *
 * @return An initialized instance of ACOColorSwatch
 */
- (instancetype)initWithVersion:(NSUInteger)version entries:(NSArray *)entries;

/**
 * The version of the aco file where the colors were loaded from.
 */
@property (nonatomic, readonly) NSUInteger version;

/**
 * Array of ACOColorEntry specifying the colors in this swatch.
 */
@property (nonatomic, readonly) NSArray *entries;

/**
 * Get a color entry given its index.
 *
 * You can get colors by index for version 1 and 2 swatches.
 *
 * @param The index to get the entry from. Must be a valid index (0 .. entries.count).
 *
 * @return The entry at the specified index.
 */
- (ACOColorEntry *)colorEntryAtIndex:(NSUInteger)index;

/**
 * Get a color entry given its name.
 *
 * Color names are only supported in version 2 swatches.
 *
 * @param name The name of the entry to fetch.
 *
 * @return The first entry in the list matching the
 *         given name, or nil if no such entry can be found.
 */
- (ACOColorEntry *)colorEntryForName:(NSString *)name;

@end
