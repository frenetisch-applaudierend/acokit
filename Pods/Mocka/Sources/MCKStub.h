//
//  MCKStub.h
//  mocka
//
//  Created by Markus Gasser on 18.07.12.
//  Copyright (c) 2012 Markus Gasser. All rights reserved.
//

#import <Foundation/Foundation.h>


@class MCKInvocationPrototype;
@protocol MCKStubAction;


@interface MCKStub : NSObject

#pragma mark - Configuration

@property (nonatomic, readonly, copy) NSArray *invocationPrototypes;
@property (nonatomic, copy) id stubBlock;

- (void)addInvocationPrototype:(MCKInvocationPrototype *)prototype;


#pragma mark - Matching and Applying

- (BOOL)matchesForInvocation:(NSInvocation *)invocation;

- (void)applyToInvocation:(NSInvocation *)invocation;

@end
