//
//  MCKTypeEncodings.m
//  mocka
//
//  Created by Markus Gasser on 21.07.12.
//  Copyright (c) 2012 Markus Gasser. All rights reserved.
//

#import "MCKTypeEncodings.h"


@implementation MCKTypeEncodings

#pragma mark - Get Information about @encode() types

+ (BOOL)isObjectType:(const char *)type {
    type = [self typeBySkippingTypeModifiers:type];
    return (type[0] == '@' || type[0] == '#');
}

+ (BOOL)isSelectorType:(const char *)type {
    type = [self typeBySkippingTypeModifiers:type];
    return (type[0] == ':');
}

+ (BOOL)isCStringType:(const char *)type {
    type = [self typeBySkippingTypeModifiers:type];
    return (type[0] == '*');
}

+ (BOOL)isPointerType:(const char *)type {
    type = [self typeBySkippingTypeModifiers:type];
    return (type[0] == '^');
}


#pragma mark - Testing for Equality

+ (BOOL)isType:(const char *)type equalToType:(const char *)other {
    type = [self typeBySkippingTypeModifiers:type];
    other = [self typeBySkippingTypeModifiers:other];
    if ([self isObjectType:type]) {
        return type[0] == other[0];
    } else {
        return (strcmp(type, other) == 0);
    }
}


#pragma mark - Prepare @encode() types

+ (const char *)typeBySkippingTypeModifiers:(const char *)type {
    while (type[0] == 'r' || type[0] == 'n' || type[0] == 'N' || type[0] == 'o' || type[0] == 'O' || type[0] == 'R' || type[0] == 'V') { type++; }
    return type;
}

@end
