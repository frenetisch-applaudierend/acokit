//
//  MCKStubbingSyntax.h
//  mocka
//
//  Created by Markus Gasser on 8.11.2013.
//  Copyright (c) 2013 konoma GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>


@class MCKLocation;
@class MCKStub;


/**
 * Stub a method call.
 */
#define mck_stub(CALL) _mck_stub(_MCKCurrentLocation(), ^{ (CALL); }).stubBlock = ^typeof(CALL)
#ifndef MCK_DISABLE_NICE_SYNTAX
    #define stub(CALL) mck_stub(CALL)
#endif


/**
 * Stub multiple method calls.
 */
#define mck_stubAll(CALLS) _mck_stub(_MCKCurrentLocation(), ^{ CALLS; }).stubBlock = ^
#ifndef MCK_DISABLE_NICE_SYNTAX
    #define stubAll(CALLS) mck_stubAll(CALLS)
#endif


/**
 * Provide actions for stubbed calls.
 */
#define mck_with
#ifndef MCK_DISABLE_NICE_SYNTAX
    #define with mck_with
#endif


#pragma mark - Internal

extern MCKStub* _mck_stub(MCKLocation *location, void(^calls)(void));
