//
//  MCKNeverVerificationHandler.h
//  mocka
//
//  Created by Markus Gasser on 22.07.12.
//  Copyright (c) 2012 Markus Gasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCKVerificationHandler.h"


@interface MCKNeverVerificationHandler : NSObject <MCKVerificationHandler>

+ (instancetype)neverHandler;

@end


// Mocking Syntax
#define mck_never  _mck_useVerificationHandler([MCKNeverVerificationHandler neverHandler])
#define mck_noMore mck_never

#ifndef MCK_DISABLE_NICE_SYNTAX
#define never  mck_never
#define noMore mck_noMore
#endif
