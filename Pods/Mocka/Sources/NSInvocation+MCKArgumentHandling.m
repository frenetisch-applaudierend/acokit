//
//  NSInvocation+MCKArgumentHandling.m
//  mocka
//
//  Created by Markus Gasser on 19.10.12.
//  Copyright (c) 2012 Markus Gasser. All rights reserved.
//

#import "NSInvocation+MCKArgumentHandling.h"
#import "MCKArgumentSerialization.h"


#define ReturnArgumentAtEffectiveIndex(type, idx) {\
    type value = (type)0;\
    [self getArgument:&value atIndex:((idx) + 2)];\
    return value;\
}


@implementation NSInvocation (MCKArgumentHandling)

#pragma mark - Retrieving Arguments

- (__autoreleasing id)mck_objectParameterAtIndex:(NSUInteger)index {
    ReturnArgumentAtEffectiveIndex(__unsafe_unretained id, index);
}

- (NSInteger)mck_integerParameterAtIndex:(NSUInteger)index {
    ReturnArgumentAtEffectiveIndex(NSInteger, index);
}

- (NSUInteger)mck_unsignedIntegerParameterAtIndex:(NSUInteger)index {
    ReturnArgumentAtEffectiveIndex(NSUInteger, index);
}

- (void *)mck_structParameter:(out void *)parameter atIndex:(NSUInteger)index {
    [self getArgument:parameter atIndex:(index + 2)];
    return parameter;
}

- (id)mck_serializedParameterAtIndex:(NSUInteger)index {
    NSUInteger paramSize = [self mck_sizeofParameterAtIndex:index];
    const char *argType = [self.methodSignature getArgumentTypeAtIndex:(index + 2)];
    UInt8 buffer[paramSize]; memset(buffer, 0, paramSize);
    [self getArgument:buffer atIndex:(index + 2)];
    return mck_encodeValueFromBytesAndType(buffer, paramSize, argType);
}

- (NSUInteger)mck_sizeofParameterAtIndex:(NSUInteger)index {
    NSUInteger size = 0;
    NSGetSizeAndAlignment([self.methodSignature getArgumentTypeAtIndex:(index + 2)], &size, NULL);
    return size;
}


#pragma mark - Getting and Setting Return Value

- (id)mck_objectReturnValue {
    __unsafe_unretained id returnValue = nil;
    [self getReturnValue:&returnValue];
    return returnValue;
}

- (void)mck_setObjectReturnValue:(id)value {
    [self setReturnValue:&value];
}

@end
