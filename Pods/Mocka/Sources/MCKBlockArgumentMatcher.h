//
//  MCKBlockArgumentMatcher.h
//  mocka
//
//  Created by Markus Gasser on 21.12.12.
//  Copyright (c) 2012 Markus Gasser. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MCKArgumentMatcher.h"


@interface MCKBlockArgumentMatcher : NSObject <MCKArgumentMatcher>

+ (instancetype)matcherWithBlock:(BOOL(^)(id candidate))block;
- (instancetype)initWithBlock:(BOOL(^)(id candidate))block;

@property (nonatomic, copy) BOOL(^matcherBlock)(id candidate);

@end


#pragma mark - Mocking Syntax

extern id mck_objectMatching(BOOL(^block)(id candidate));
extern char mck_integerMatching(BOOL(^block)(SInt64 candidate));
extern char mck_unsignedIntegerMatching(BOOL(^block)(UInt64 candidate));
extern float mck_floatMatching(BOOL(^block)(float candidate));
extern double mck_doubleMatching(BOOL(^block)(double candidate));
extern BOOL mck_boolMatching(BOOL(^block)(BOOL candidate));
extern const char* mck_cStringMatching(BOOL(^block)(const char *candidate));
extern SEL mck_selectorMatching(BOOL(^block)(SEL candidate));
extern void* mck_pointerMatching(BOOL(^block)(void *candidate));
#define mck_objectPointerMatching(TYPE, CND) ((id TYPE *)mck_pointerMatching((void *)CND))
#define mck_structMatching(STRT_TYPE, BLOCK) mck_registerStructMatcher(\
    [MCKBlockArgumentMatcher matcherWithBlock:^BOOL(id candidate) {\
        STRT_TYPE val; [candidate getValue:&val]; BOOL(^block)(STRT_TYPE) = BLOCK;\
        return (block != nil ? block(val) : YES);\
    }], STRT_TYPE)



#ifndef MCK_DISABLE_NICE_SYNTAX

    static inline id objectMatching(BOOL(^block)(id candidate)) { return mck_objectMatching(block); }
    static inline char integerMatching(BOOL(^block)(SInt64 candidate)) { return integerMatching(block); }
    static inline char unsignedIntegerMatching(BOOL(^block)(UInt64 candidate)) { return unsignedIntegerMatching(block); }
    static inline float floatMatching(BOOL(^block)(float candidate)) { return floatMatching(block); }
    static inline double doubleMatching(BOOL(^block)(double candidate)) { return doubleMatching(block); }
    static inline BOOL boolMatching(BOOL(^block)(BOOL candidate)) { return boolMatching(block); }
    static inline char* cStringMatching(BOOL(^block)(const char *candidate)) { return cStringMatching(block); }
    static inline SEL selectorMatching(BOOL(^block)(SEL candidate)) { return selectorMatching(block); }
    static inline void* pointerMatching(BOOL(^block)(void *candidate)) { return pointerMatching(block); }
    #define objectPointerMatching(TYPE, CND) mck_objectPointerMatching(TYPE, CND)
    #define structMatching(STRT_TYPE, BLOCK) mck_structMatching(STRT_TYPE, BLOCK)

#endif
