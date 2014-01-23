//
//  MCKInvocationStubber.h
//  mocka
//
//  Created by Markus Gasser on 06.10.12.
//  Copyright (c) 2012 Markus Gasser. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MCKStub;
@class MCKInvocationPrototype;
@protocol MCKStubAction;


@interface MCKInvocationStubber : NSObject

#pragma mark - Creating and Updating Stubs

- (void)recordStubPrototype:(MCKInvocationPrototype *)prototype;
- (void)finishRecordingStubGroup;


#pragma mark - Applying Stub Actions

@property (nonatomic, readonly) NSArray *recordedStubs;

- (BOOL)hasStubsRecordedForInvocation:(NSInvocation *)invocation;
- (void)applyStubsForInvocation:(NSInvocation *)invocation;

@end
