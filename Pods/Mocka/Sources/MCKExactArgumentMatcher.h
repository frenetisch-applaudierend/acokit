//
//  MCKExactArgumentMatcher.h
//  mocka
//
//  Created by Markus Gasser on 22.12.12.
//  Copyright (c) 2012 Markus Gasser. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MCKArgumentMatcher.h"


@interface MCKExactArgumentMatcher : NSObject <MCKArgumentMatcher>

+ (instancetype)matcherWithArgument:(id)expected;
- (instancetype)initWithArgument:(id)expected;

@property (nonatomic, strong) id expectedArgument;

@end


#pragma mark - Mocking Syntax

extern char mck_intArg(int64_t arg);
extern char mck_unsignedIntArg(uint64_t arg);
extern float mck_floatArg(float arg);
extern double mck_doubleArg(double arg);
extern BOOL mck_boolArg(BOOL arg);
extern char* mck_cStringArg(const char *arg);
extern SEL mck_selectorArg(SEL arg);
extern void* mck_pointerArg(void *arg);
#define mck_objectPointerArg(TYPE, ARG) ((id TYPE *)mck_pointerArg(ARG))
#define mck_structArg(arg) mck_registerStructMatcher(\
    [MCKExactArgumentMatcher matcherWithArgument:[NSValue valueWithBytes:(typeof(arg)[]){ (arg) }\
                                                  objCType:@encode(typeof(arg))]], typeof(arg))

#ifndef MCK_DISABLE_NICE_SYNTAX

    static inline char intArg(int64_t arg) { return mck_intArg(arg); }
    static inline char unsignedIntArg(uint64_t arg) { return mck_unsignedIntArg(arg); }
    static inline float floatArg(float arg) { return mck_floatArg(arg); }
    static inline BOOL boolArg(BOOL arg) { return mck_boolArg(arg); }
    static inline char* cStringArg(const char *arg) { return mck_cStringArg(arg); }
    static inline SEL selectorArg(SEL arg) { return mck_selectorArg(arg); }
    static inline void* pointerArg(void *arg) { return mck_pointerArg(arg); }
    #define objectPointerArg(TYPE, ARG) mck_objectPointerArg(TYPE, ARG)
    #define structArg(arg) mck_structArg(arg)

#endif
