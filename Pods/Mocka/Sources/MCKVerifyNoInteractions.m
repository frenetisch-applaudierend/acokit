//
//  MCKVerifyNoInteractions.m
//  mocka
//
//  Created by Markus Gasser on 22.07.12.
//  Copyright (c) 2012 Markus Gasser. All rights reserved.
//

#import "MCKVerifyNoInteractions.h"

#import "MCKMockingContext.h"
#import "MCKInvocationRecorder.h"


void mck_checkNoInteractions(id mockObject) {
    MCKMockingContext *context = [MCKMockingContext currentContext];
    MCKInvocationRecorder *invocationRecorder = context.invocationRecorder;
    
    for (NSInvocation *invocation in invocationRecorder.recordedInvocations) {
        if (invocation.target == mockObject) {
            [context failWithReason:@"Expected no more interactions on %@, but still had", mockObject];
            break;
        }
    }
}
