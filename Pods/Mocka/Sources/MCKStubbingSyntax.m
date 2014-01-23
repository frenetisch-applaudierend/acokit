//
//  MCKStubbingSyntax.m
//  mocka
//
//  Created by Markus Gasser on 8.11.2013.
//  Copyright (c) 2013 konoma GmbH. All rights reserved.
//

#import "MCKStubbingSyntax.h"
#import "MCKMockingContext.h"


MCKStub* _mck_stub(MCKLocation *location, void(^calls)(void)) {
    MCKMockingContext *context = [MCKMockingContext currentContext];
    context.currentLocation = location;
    return [context stubCalls:calls];
}
