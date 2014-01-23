//
//  MCKVerificationResult.m
//  mocka
//
//  Created by Markus Gasser on 30.9.2013.
//  Copyright (c) 2013 konoma GmbH. All rights reserved.
//

#import "MCKVerificationResult.h"


@implementation MCKVerificationResult

#pragma mark - Initialization

+ (instancetype)successWithMatchingIndexes:(NSIndexSet *)matches {
    return [[self alloc] initWithSuccess:YES failureReason:nil matchingIndexes:matches];
}

+ (instancetype)failureWithReason:(NSString *)reason matchingIndexes:(NSIndexSet *)matches {
    return [[self alloc] initWithSuccess:NO failureReason:reason matchingIndexes:matches];
}

- (instancetype)initWithSuccess:(BOOL)success failureReason:(NSString *)failureReason matchingIndexes:(NSIndexSet *)matches {
    if ((self = [super init])) {
        _success = success;
        _failureReason = [failureReason copy];
        _matchingIndexes = (matches != nil ? [matches copy] : [NSIndexSet indexSet]);
    }
    return self;
}


#pragma mark - Equality Testing

- (NSUInteger)hash {
    return (self.success | ([self.failureReason hash] ^ [self.matchingIndexes hash]));
}

- (BOOL)isEqual:(id)object {
    if (object == self) { return YES; }
    else if (object == nil || [object class] != [self class]) { return NO; }
    typeof(self) other = object;
    
    return (self.success == other.success
            && (self.failureReason == other.failureReason || [self.failureReason isEqualToString:other.failureReason])
            && (self.matchingIndexes == other.matchingIndexes || [self.matchingIndexes isEqualToIndexSet:other.matchingIndexes]));
}


#pragma mark - Debugging

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: %p", [self class], self];
    [description appendFormat:@" success=%@", (self.success ? @"YES" : @"NO")];
    if (!self.success) {
        [description appendFormat:@" failureReason='%@'", self.failureReason];
    }
    [description appendFormat:@" matchingIndexes=%@>", self.matchingIndexes];
    return description;
}

@end
