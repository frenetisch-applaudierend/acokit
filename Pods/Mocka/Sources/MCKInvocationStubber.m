//
//  MCKInvocationStubber.m
//  mocka
//
//  Created by Markus Gasser on 06.10.12.
//  Copyright (c) 2012 Markus Gasser. All rights reserved.
//

#import "MCKInvocationStubber.h"
#import "MCKStub.h"
#import "MCKInvocationPrototype.h"


@implementation MCKInvocationStubber {
    NSMutableArray *_recordedStubs;
    BOOL _groupRecording;
}

#pragma mark - Initialization

- (instancetype)init {
    if ((self = [super init])) {
        _recordedStubs = [NSMutableArray array];
    }
    return self;
}


#pragma mark - Creating and Updating Stubbings

- (void)recordStubPrototype:(MCKInvocationPrototype *)prototype {
    if (![self isRecordingInvocationGroup]) {
        [self pushNewStubForRecordingInvocationGroup];
    }
    [[self activeStub] addInvocationPrototype:prototype];
}

- (void)finishRecordingStubGroup {
    NSAssert([self isRecordingInvocationGroup], @"Finish called while not recording");
    
    [self endRecordingInvocationGroup];
}


#pragma mark - Querying and Applying Stubbings

- (NSArray *)recordedStubs {
    return [_recordedStubs copy];
}

- (BOOL)hasStubsRecordedForInvocation:(NSInvocation *)invocation {
    NSParameterAssert(invocation != nil);
    
    NSUInteger index = [_recordedStubs indexOfObjectPassingTest:^BOOL(MCKStub *stub, NSUInteger idx, BOOL *stop) {
        return [stub matchesForInvocation:invocation];
    }];
    return (index != NSNotFound);
}

- (void)applyStubsForInvocation:(NSInvocation *)invocation {
    NSParameterAssert(invocation != nil);
    
    for (MCKStub *stub in _recordedStubs) {
        if ([stub matchesForInvocation:invocation]) {
            [stub applyToInvocation:invocation];
        }
    }
}


#pragma mark - Managing Invocation Group Recording

- (BOOL)isRecordingInvocationGroup {
    return _groupRecording;
}

- (void)pushNewStubForRecordingInvocationGroup {
    _groupRecording = YES;
    [_recordedStubs addObject:[[MCKStub alloc] init]];
}

- (void)endRecordingInvocationGroup {
    _groupRecording = NO;
}

- (MCKStub *)activeStub {
    return [_recordedStubs lastObject];
}

@end
