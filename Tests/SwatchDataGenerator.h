//
//  SwatchDataGenerator.h
//  ACOKit
//
//  Created by Markus Gasser on 23/01/14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACOColorEntry.h"


extern NSData* DataForHeader(NSUInteger version, NSUInteger count);
extern NSData* DataForV1Entry(ACOColorSpace colorSpace, ACOColorData data);
extern NSData* DataForV2Entry(ACOColorSpace colorSpace, ACOColorData data, NSString *name);
