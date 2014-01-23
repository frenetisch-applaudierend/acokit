//
//  XCTestCase+MCKContextLoading.m
//  mocka
//
//  Created by Markus Gasser on 10.11.2013.
//  Copyright (c) 2013 konoma GmbH. All rights reserved.
//

#import "XCTestCase+MCKContextLoading.h"
#import "MCKMockingContext.h"

#import <objc/runtime.h>


@implementation XCTestCase (MCKContextLoading)

+ (void)load {
    Method originalMethod = class_getInstanceMethod(self, @selector(invokeTest));
    Method swizzledMethod = class_getInstanceMethod(self, @selector(mck_loadContext_invokeTest));
    method_exchangeImplementations(originalMethod, swizzledMethod);
}


- (void)mck_loadContext_invokeTest {
    MCKMockingContext *context = [[MCKMockingContext alloc] initWithTestCase:self];
    [MCKMockingContext setCurrentContext:context];
    [self mck_loadContext_invokeTest]; // invoke original method
    [MCKMockingContext setCurrentContext:nil];
}

@end
