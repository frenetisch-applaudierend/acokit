//
//  ACOColorEntryParser.h
//  ACOKit
//
//  Created by Markus Gasser on 22.01.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>


@class ACOColorEntry;


@interface ACOColorEntryParser : NSObject

- (ACOColorEntry *)parseColorEntryWithVersion:(NSUInteger)version fromStream:(NSInputStream *)stream error:(NSError **)error;

@end
