//
//  ACOColorSwatch+UIKit.h
//  ACOKit
//
//  Created by Markus Gasser on 22.01.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACOColorSwatch.h"


@interface ACOColorSwatch (UIKit)

- (UIColor *)colorAtIndex:(NSUInteger)index;
- (UIColor *)colorForName:(NSString *)name;

- (UIColor *)objectAtIndexedSubscript:(NSUInteger)idx;
- (UIColor *)objectForKeyedSubscript:(NSString *)key;

@end
