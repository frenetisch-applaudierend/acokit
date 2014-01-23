//
//  MCKArgumentMatcherRecorder.h
//  mocka
//
//  Created by Markus Gasser on 14.10.12.
//  Copyright (c) 2012 Markus Gasser. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol MCKArgumentMatcher;
@class MCKMockingContext;


@interface MCKArgumentMatcherRecorder : NSObject

#pragma mark - Initialization

- (instancetype)initWithMockingContext:(MCKMockingContext *)context;

@property (nonatomic, readonly, weak) MCKMockingContext *mockingContext;


#pragma mark - Adding and Reading Matchers

@property (nonatomic, readonly) NSArray *argumentMatchers;

- (UInt8)addPrimitiveArgumentMatcher:(id<MCKArgumentMatcher>)matcher;
- (UInt8)addObjectArgumentMatcher:(id<MCKArgumentMatcher>)matcher;

- (NSArray *)collectAndReset; // Return all matchers and then reset


#pragma mark - Validating the Collection

- (BOOL)isValidForMethodSignature:(NSMethodSignature *)signature reason:(NSString **)reason;

@end
