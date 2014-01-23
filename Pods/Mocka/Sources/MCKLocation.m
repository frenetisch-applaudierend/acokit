//
//  MCKTestLocation.m
//  mocka
//
//  Created by Markus Gasser on 3.11.2013.
//  Copyright (c) 2013 konoma GmbH. All rights reserved.
//

#import "MCKLocation.h"


@implementation MCKLocation

#pragma mark - Initialization

+ (instancetype)locationWithFileName:(NSString *)fileName lineNumber:(NSUInteger)lineNumber {
    return [[self alloc] initWithFileName:fileName lineNumber:lineNumber];
}

- (instancetype)initWithFileName:(NSString *)fileName lineNumber:(NSUInteger)lineNumber {
    if ((self = [super init])) {
        _fileName = [fileName copy];
        _lineNumber = lineNumber;
    }
    return self;
}


#pragma mark - Equality

- (NSUInteger)hash {
    return ([self.fileName hash] ^ self.lineNumber);
}

- (BOOL)isEqual:(id)object {
    if (object == self) { return YES; }
    else if (object == nil || [object class] != [self class]) { return NO; }
    typeof(self) other = object;
    
    return ((self.fileName == other.fileName || [self.fileName isEqualToString:other.fileName])
            && self.lineNumber == other.lineNumber);
}


#pragma mark - NSCopying Support

- (instancetype)copyWithZone:(NSZone *)zone {
    return self;
}

@end
