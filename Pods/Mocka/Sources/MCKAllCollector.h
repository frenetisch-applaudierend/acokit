//
//  MCKAllCollector.h
//  mocka
//
//  Created by Markus Gasser on 8.11.2013.
//  Copyright (c) 2013 konoma GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCKVerificationResultCollector.h"


@interface MCKAllCollector : NSObject <MCKVerificationResultCollector>

@end


/**
 * Verify that all calls of a group are made in any order.
 */
#define mck_verifyAll mck_verifyUsingCollector([[MCKAllCollector alloc] init])
#ifndef MCK_DISABLE_NICE_SYNTAX
    #define verifyAll mck_verifyAll
#endif
