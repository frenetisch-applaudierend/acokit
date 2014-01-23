//
//  MCKArgumentSerialization.m
//  mocka
//
//  Created by Markus Gasser on 22.12.12.
//  Copyright (c) 2012 Markus Gasser. All rights reserved.
//

#import "MCKArgumentSerialization.h"


#pragma mark - Generic Encoding

id mck_encodeValueFromBytesAndType(const void *bytes, size_t size, const char *type) {
    type = [MCKTypeEncodings typeBySkippingTypeModifiers:type];
    
    switch (type[0]) {
        case '@': return mck_encodeObjectArgument(*(__unsafe_unretained id *)bytes);
        case '#': return mck_encodeObjectArgument(*((Class *)bytes));
            
        case 'c': return mck_encodeSignedIntegerArgument(*(char *)bytes);
        case 'i': return mck_encodeSignedIntegerArgument(*(int *)bytes);
        case 's': return mck_encodeSignedIntegerArgument(*(short *)bytes);
        case 'l': return mck_encodeSignedIntegerArgument(*(long *)bytes);
        case 'q': return mck_encodeSignedIntegerArgument(*(long long *)bytes);
            
        case 'C': return mck_encodeUnsignedIntegerArgument(*(unsigned char *)bytes);
        case 'I': return mck_encodeUnsignedIntegerArgument(*(unsigned int *)bytes);
        case 'S': return mck_encodeUnsignedIntegerArgument(*(unsigned short *)bytes);
        case 'L': return mck_encodeUnsignedIntegerArgument(*(unsigned long *)bytes);
        case 'Q': return mck_encodeUnsignedIntegerArgument(*(unsigned long long *)bytes);
            
        case 'f': return mck_encodeFloatingPointArgument(*(float *)bytes);
        case 'd': return mck_encodeFloatingPointArgument(*(double *)bytes);
            
        case 'B': return mck_encodeBooleanArgument(*(_Bool *)bytes);
            
        case '*': return mck_encodeCStringArgument(*(void **)bytes);
            
        case ':': return mck_encodeSelectorArgument(*(SEL *)bytes);
        
        case '^':
        case '[': return mck_encodePointerArgument(*(void **)bytes);
            
        case '{': return mck_encodeStructBytes(bytes, type);
            
        default: {
            NSString *reason = [NSString stringWithFormat:@"Unknown type encoding: %s", type];
            @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:nil];
        }
    }
}


#pragma mark - Object Arguments

id mck_encodeObjectArgument(id arg) {
    return arg;
}

id mck_decodeObjectArgument(id serialized) {
    return serialized;
}


#pragma mark - Primitive Arguments

id mck_encodeSignedIntegerArgument(SInt64 arg) {
    return @(arg);
}

SInt64 mck_decodeSignedIntegerArgument(id serialized) {
    return [serialized longLongValue];
}

id mck_encodeUnsignedIntegerArgument(UInt64 arg) {
    return @(arg);
}

SInt64 mck_decodeUnsignedIntegerArgument(id serialized) {
    return [serialized unsignedLongLongValue];
}

id mck_encodeFloatingPointArgument(double arg) {
    return @(arg);
}

double mck_decodeFloatingPointArgument(id serialized) {
    return [serialized doubleValue];
}

id mck_encodeBooleanArgument(BOOL arg) {
    return @(arg);
}

BOOL mck_decodeBooleanArgument(id serialized) {
    return [serialized boolValue];
}


#pragma mark - Non-Object Pointer Types

id mck_encodePointerArgument(const void *arg) {
    return [NSValue valueWithPointer:arg];
}

void* mck_decodePointerArgument(id serialized) {
    return [serialized pointerValue];
}

id mck_encodeCStringArgument(const char *arg) {
    return [NSString stringWithUTF8String:arg];
}

const char* mck_decodeCStringArgument(id serialized) {
    return [serialized UTF8String];
}

id mck_encodeSelectorArgument(SEL arg) {
    return (arg != NULL ? NSStringFromSelector(arg) : nil);
}

SEL mck_decodeSelectorArgument(id serialized) {
    return (serialized != nil ? NSSelectorFromString(serialized) : NULL);
}

id mck_encodeStructBytes(const void *arg, const char *type) {
    return [NSValue valueWithBytes:arg objCType:type];
}

void* mck_decodeStructBytes(id serialized, void *arg) {
    [serialized getValue:arg];
    return arg;
}
