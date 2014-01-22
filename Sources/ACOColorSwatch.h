//
//  ACOColorSwatch.h
//  ACOKit
//
//  Created by Markus Gasser on 22.01.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>


@class ACOColorEntry;


@interface ACOColorSwatch : NSObject

+ (instancetype)colorSwatchFromFileAtURL:(NSURL *)url;

- (instancetype)initWithVersion:(NSUInteger)version entries:(NSArray *)entries;

@property (nonatomic, readonly) NSUInteger version;
@property (nonatomic, readonly) NSArray *entries;

- (ACOColorEntry *)colorEntryAtIndex:(NSUInteger)index;
- (ACOColorEntry *)colorEntryForName:(NSString *)name;

@end
