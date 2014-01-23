//
//  MCKArgumentMatcher.h
//  mocka
//
//  Created by Markus Gasser on 22.07.12.
//  Copyright (c) 2012 Markus Gasser. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol MCKArgumentMatcher <NSObject>

- (BOOL)matchesCandidate:(id)candidate;

@end


#pragma mark - Registering Matchers

extern id mck_registerObjectMatcher(id<MCKArgumentMatcher> matcher);
extern UInt8 mck_registerPrimitiveNumberMatcher(id<MCKArgumentMatcher> matcher);
extern char* mck_registerCStringMatcher(id<MCKArgumentMatcher> matcher);
extern SEL mck_registerSelectorMatcher(id<MCKArgumentMatcher> matcher);
extern void* mck_registerPointerMatcher(id<MCKArgumentMatcher> matcher);

#define mck_registerStructMatcher(MATCHER, STRT_TYPE)\
    (*((STRT_TYPE *)_mck_registerStructMatcher((MATCHER), &(STRT_TYPE){}, sizeof(STRT_TYPE))))
extern const void* _mck_registerStructMatcher(id<MCKArgumentMatcher> matcher, void *inputStruct, size_t structSize);


#pragma mark - Find Registered Matchers

extern UInt8 mck_matcherIndexForArgumentBytes(const void *bytes);
