//
//  MCKInvocationVerifier.h
//  mocka
//
//  Created by Markus Gasser on 30.9.2013.
//  Copyright (c) 2013 konoma GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol MCKInvocationVerifierDelegate;
@protocol MCKVerificationResultCollector;
@protocol MCKVerificationHandler;

@class MCKMockingContext;
@class MCKInvocationRecorder;
@class MCKInvocationPrototype;


@interface MCKInvocationVerifier : NSObject

#pragma mark - Initialization

- (instancetype)initWithMockingContext:(MCKMockingContext *)context;

@property (nonatomic, readonly, weak) MCKMockingContext *mockingContext;


#pragma mark - Configuration

@property (nonatomic, assign) NSTimeInterval timeout; // reset to 0.0 after each verified call
@property (nonatomic, readonly) id<MCKVerificationHandler> verificationHandler;


#pragma mark - Verification

- (void)beginVerificationWithCollector:(id<MCKVerificationResultCollector>)collector;
- (void)useVerificationHandler:(id<MCKVerificationHandler>)verificationHandler;
- (void)verifyInvocationsForPrototype:(MCKInvocationPrototype *)prototype;
- (void)finishVerification;

@end
