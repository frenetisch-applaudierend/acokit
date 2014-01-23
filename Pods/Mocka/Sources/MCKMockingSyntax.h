//
//  MCKMockingSyntax.h
//  mocka
//
//  Created by Markus Gasser on 25.9.2013.
//
//

#import <Foundation/Foundation.h>

#import "MCKLocation.h"

@class MCKStub;


#pragma mark - Creating Mocks and Spies

// safe syntax
#define mck_mock(CLS, ...)        _mck_createMock(_MCKCurrentLocation(), @[ (CLS), ## __VA_ARGS__ ])
#define mck_mockForClass(CLS)     (CLS *)mck_mock([CLS class])
#define mck_mockForProtocol(PROT) (id<PROT>)mck_mock(@protocol(PROT))
#define mck_spy(OBJ)              (typeof(OBJ))_mck_createSpy(_MCKCurrentLocation(), (OBJ))

// nice syntax
#ifndef MCK_DISABLE_NICE_SYNTAX

    #define mock(CLS, ...)        mck_mock(CLS, __VA_ARGS__)
    #define mockForClass(CLS)     mck_mockForClass(CLS)
    #define mockForProtocol(PROT) mck_mockForProtocol(PROT)
    #define spy(OBJ)              mck_spy(OBJ)

#endif


#pragma mark - Internal Bridging

extern id _mck_createMock(MCKLocation *location, NSArray *classAndProtocols);
extern id _mck_createSpy(MCKLocation *location, id object);
