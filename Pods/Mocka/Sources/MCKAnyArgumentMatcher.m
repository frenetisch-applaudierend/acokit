//
//  MCKAnyArgumentMatcher.m
//  mocka
//
//  Created by Markus Gasser on 10.09.12.
//  Copyright (c) 2012 Markus Gasser. All rights reserved.
//

#import "MCKAnyArgumentMatcher.h"


@implementation MCKAnyArgumentMatcher

- (BOOL)matchesCandidate:(id)candidate {
    return YES;
}

@end


#pragma mark - Mocking Syntax

id mck_anyObject(void) {
    return mck_registerObjectMatcher([[MCKAnyArgumentMatcher alloc] init]);
}

UInt8 mck_anyInt(void) {
    return mck_registerPrimitiveNumberMatcher([[MCKAnyArgumentMatcher alloc] init]);
}

float mck_anyFloat(void) {
    return mck_registerPrimitiveNumberMatcher([[MCKAnyArgumentMatcher alloc] init]);
}

BOOL mck_anyBool(void) {
    return mck_anyInt();
}

char* mck_anyCString(void) {
    return mck_registerCStringMatcher([[MCKAnyArgumentMatcher alloc] init]);
}

SEL mck_anySelector(void) {
    return mck_registerSelectorMatcher([[MCKAnyArgumentMatcher alloc] init]);
}

void* mck_anyPointer(void) {
    return mck_registerPointerMatcher([[MCKAnyArgumentMatcher alloc] init]);
}
