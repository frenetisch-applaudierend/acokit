//
//  MCKArgumentSerialization.h
//  mocka
//
//  Created by Markus Gasser on 22.12.12.
//  Copyright (c) 2012 Markus Gasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCKTypeEncodings.h"


#pragma mark - Generic Encoding

id mck_encodeValueFromBytesAndType(const void *bytes, size_t size, const char *type);


#pragma mark - Object Arguments

id mck_encodeObjectArgument(id arg);
id mck_decodeObjectArgument(id serialized);


#pragma mark - Primitive Arguments

id mck_encodeSignedIntegerArgument(SInt64 arg);
SInt64 mck_decodeSignedIntegerArgument(id serialized);

id mck_encodeUnsignedIntegerArgument(UInt64 arg);
SInt64 mck_decodeUnsignedIntegerArgument(id serialized);

id mck_encodeFloatingPointArgument(double arg);
double mck_decodeFloatingPointArgument(id serialized);

id mck_encodeBooleanArgument(BOOL arg);
BOOL mck_decodeBooleanArgument(id serialized);


#pragma mark - Non-Object Pointer Types

id mck_encodePointerArgument(const void *arg);
void* mck_decodePointerArgument(id serialized);

id mck_encodeCStringArgument(const char *arg);
const char* mck_decodeCStringArgument(id serialized);

id mck_encodeSelectorArgument(SEL arg);
SEL mck_decodeSelectorArgument(id serialized);

id mck_encodeStructBytes(const void *arg, const char *type);
void* mck_decodeStructBytes(id serialized, void *arg);

#define mck_encodeStructArgument(arg) mck_encodeStructBytes((typeof(arg)[]){ (arg) }, @encode(typeof(arg)))
#define mck_decodeStructArgument(serialized, structType) *((structType *)mck_decodeStructBytes(serialized, &(structType){}))
