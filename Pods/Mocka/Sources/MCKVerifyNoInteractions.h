//
//  MCKVerifyNoInteractions.h
//  mocka
//
//  Created by Markus Gasser on 22.07.12.
//  Copyright (c) 2012 Markus Gasser. All rights reserved.
//

#import <Foundation/Foundation.h>


// Mocking Syntax
#define mck_verifyNoMoreInteractionsOn(mock) mck_verifyCall(mck_checkNoInteractions(mock))
#define mck_verifyNoInteractionsOn(mock)     mck_verifyCall(mck_checkNoInteractions(mock))

#ifndef MCK_DISABLE_NICE_SYNTAX

    #define verifyNoMoreInteractionsOn(mock) mck_verifyNoMoreInteractionsOn((mock))
    #define verifyNoInteractionsOn(mock)     mck_verifyNoInteractionsOn((mock))

#endif

extern void mck_checkNoInteractions(id mockObject);
