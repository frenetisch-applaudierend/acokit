//
//  MCKTypeEncodings.h
//  mocka
//
//  Created by Markus Gasser on 20.07.12.
//  Copyright (c) 2012 Markus Gasser. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface MCKTypeEncodings : NSObject

#pragma mark - Get Information about @encode() types

+ (BOOL)isObjectType:(const char *)type;
+ (BOOL)isSelectorType:(const char *)type;
+ (BOOL)isCStringType:(const char *)type;
+ (BOOL)isPointerType:(const char *)type;


#pragma mark - Testing for Equality

+ (BOOL)isType:(const char *)type equalToType:(const char *)other;

#pragma mark - Prepare @encode() types

+ (const char *)typeBySkippingTypeModifiers:(const char *)type;

@end
