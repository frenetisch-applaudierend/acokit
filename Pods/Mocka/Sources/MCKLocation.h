//
//  MCKTestLocation.h
//  mocka
//
//  Created by Markus Gasser on 3.11.2013.
//  Copyright (c) 2013 konoma GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MCKLocation : NSObject <NSCopying>

+ (instancetype)locationWithFileName:(NSString *)fileName lineNumber:(NSUInteger)lineNumber;

@property (nonatomic, readonly) NSString *fileName;
@property (nonatomic, readonly) NSUInteger lineNumber;

@end

#define _MCKCurrentLocation() [MCKLocation locationWithFileName:[NSString stringWithUTF8String:__FILE__] lineNumber:__LINE__]
