//
//  MCKExactlyVerificationHandler.h
//  mocka
//
//  Created by Markus Gasser on 22.07.12.
//  Copyright (c) 2012 Markus Gasser. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MCKVerificationHandler.h"


@interface MCKExactlyVerificationHandler : NSObject <MCKVerificationHandler>

+ (instancetype)exactlyHandlerWithCount:(NSUInteger)count;
- (instancetype)initWithCount:(NSUInteger)count;

@property (nonatomic, readonly) NSUInteger count;

@end


// Mocking Syntax
#define mck_exactly(COUNT) _mck_useVerificationHandler([MCKExactlyVerificationHandler exactlyHandlerWithCount:(COUNT)])
#define mck_once           mck_exactly(1)

#ifndef MCK_DISABLE_NICE_SYNTAX
#define exactly(COUNT) mck_exactly(COUNT)
#define once           mck_once
#endif
