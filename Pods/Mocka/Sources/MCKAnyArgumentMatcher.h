//
//  MCKAnyArgumentMatcher.h
//  mocka
//
//  Created by Markus Gasser on 10.09.12.
//  Copyright (c) 2012 Markus Gasser. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MCKArgumentMatcher.h"


@interface MCKAnyArgumentMatcher : NSObject <MCKArgumentMatcher>
@end


#pragma mark - Mocking Syntax

extern id mck_anyObject(void);
extern UInt8 mck_anyInt(void);
extern float mck_anyFloat(void);
extern BOOL mck_anyBool(void);
extern char* mck_anyCString(void);
extern SEL mck_anySelector(void);
extern void* mck_anyPointer(void);

#define mck_anyObjectPointer(TYPE) ((id TYPE *)mck_anyPointer())
#define mck_anyStruct(STRT_TYPE)   mck_registerStructMatcher([[MCKAnyArgumentMatcher alloc] init], STRT_TYPE)


#ifndef MCK_DISABLE_NICE_SYNTAX

    static inline id anyObject(void) { return mck_anyObject(); }
    static inline char anyInt(void) { return mck_anyInt(); }
    static inline float anyFloat(void) { return mck_anyFloat(); }
    static inline BOOL anyBool(void) { return mck_anyBool(); }
    static inline char* anyCString(void) { return mck_anyCString(); }
    static inline SEL anySelector(void) { return mck_anySelector(); }
    static inline void* anyPointer(void) { return mck_anyPointer(); }

    #define anyObjectPointer(TYPE) mck_anyObjectPointer(TYPE)
    #define anyStruct(structType)  mck_anyStruct(structType)

#endif
