//
//  MCKNetworkMock.m
//  mocka
//
//  Created by Markus Gasser on 26.10.2013.
//  Copyright (c) 2013 konoma GmbH. All rights reserved.
//

#import "MCKNetworkMock.h"
#import "MCKNetworkMock_Private.h"
#import "MCKMockObject.h"
#import "MCKNetworkRequestMatcher.h"

#import "MCKMockingContext.h"
#import "MCKInvocationStubber.h"

#import "NSInvocation+MCKArgumentHandling.h"
#import "OHHTTPStubsResponse+JSON.h"

#import <objc/runtime.h>


static inline Class StubsClass() {
    static dispatch_once_t onceToken;
    static Class cls = nil;
    dispatch_once(&onceToken, ^{
        cls = NSClassFromString(@"OHHTTPStubs");
    });
    return cls;
}

static inline Class StubsResponseClass() {
    static dispatch_once_t onceToken;
    static Class cls = nil;
    dispatch_once(&onceToken, ^{
        cls = NSClassFromString(@"OHHTTPStubsResponse");
    });
    return cls;
}


@implementation MCKNetworkMock

#pragma mark - Initialization

+ (void)initialize {
    if (!(self == [MCKNetworkMock class])) {
        return;
    }
    
    // Check that OHHTTPStubs is available
    if (StubsClass() == nil) {
        NSLog(@"****************************************************************");
        NSLog(@"* Mocka could not find the OHHTTPStubs library                 *");
        NSLog(@"* Make sure you have the library linked in your testing target *");
        NSLog(@"****************************************************************");
        abort();
    }
}

+ (instancetype)mockForContext:(MCKMockingContext *)context {
    NSParameterAssert(context != nil);
    
    static NSUInteger MockKey;
    
    MCKNetworkMock *mock = objc_getAssociatedObject(context, &MockKey);
    if (mock == nil) {
        mock = [[self alloc] initWithMockingContext:context];
        objc_setAssociatedObject(context, &MockKey, mock, OBJC_ASSOCIATION_RETAIN);
    }
    return mock;
}

- (instancetype)initWithMockingContext:(MCKMockingContext *)context {
    if ((self = [super init])) {
        _mockingContext = context;
        _enabled = YES;
        _stubsDescriptor = [self setupStubsDescriptor];
    }
    return self;
}

- (id<OHHTTPStubsDescriptor>)setupStubsDescriptor {
    __weak typeof(self) weakSelf = self;
    return [StubsClass() stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [weakSelf shouldStubRequest:request];
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [weakSelf responseForRequest:request];
    }];
}

- (void)dealloc {
    [StubsClass() removeStub:self.stubsDescriptor];
}


#pragma mark - Stubs Implementation

- (BOOL)shouldStubRequest:(NSURLRequest *)request {
    BOOL hasResponse = [self hasResponseForRequest:request];
    if (!hasResponse) {
        // If there is no response we need to record the call, otherwise it can't be verified later.
        // Otherwise, if there is a stubbed response, then the recording will be done when the stubbing is applied.
        [self responseForRequest:request];
    }
    return hasResponse;
}


#pragma mark - Network Control

- (void)disable {
    _enabled = NO;
}

- (void)enable {
    _enabled = YES;
}

- (void)startObservingNetworkCalls {
    // dummy method, only needed to have the sharedMock initialized
}


#pragma mark - Request Configuration

- (MCKNetworkActivity)GET {
    return ^(id urlParam) {
        NSURL *url = [self URLFromURLParameter:urlParam];
        MCKNetworkRequestMatcher *matcher =  [MCKNetworkRequestMatcher matcherForURL:url HTTPMethod:@"GET"];
        [self.mockingContext handleInvocation:[self handlerInvocationForRequest:matcher]];
        return matcher;
    };
}

- (NSURL *)URLFromURLParameter:(id)url {
    return ((url == nil || [url isKindOfClass:[NSURL class]]) ? url : [NSURL URLWithString:url]);
}

- (NSInvocation *)handlerInvocationForRequest:(id)request {
    NSMethodSignature *signature = [self methodSignatureForSelector:@selector(handleNetworkRequest:)];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = self;
    invocation.selector = @selector(handleNetworkRequest:);
    [invocation setArgument:&request atIndex:2];
    [invocation retainArguments];
    return invocation;
}


#pragma mark - Getting Request Info

- (BOOL)hasResponseForRequest:(NSURLRequest *)request {
    // if the network is disabled, we will return an error response
    return (![self isEnabled]
            || [self.mockingContext.invocationStubber hasStubsRecordedForInvocation:[self handlerInvocationForRequest:request]]);
}

- (OHHTTPStubsResponse *)responseForRequest:(NSURLRequest *)request {
    NSInvocation *invocation = [self handlerInvocationForRequest:request];
    [self.mockingContext handleInvocation:invocation]; // process the stubbings
    return [self responseForReturnValue:[invocation mck_objectReturnValue]];
}

- (OHHTTPStubsResponse *)responseForReturnValue:(id)value {
    if (value == nil) {
        NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorNotConnectedToInternet userInfo:nil];
        return [StubsResponseClass() responseWithError:error];
    } else if ([value isKindOfClass:StubsResponseClass()]) {
        return value;
    } else if ([value isKindOfClass:[NSData class]]) {
        return [StubsResponseClass() responseWithData:value statusCode:200 headers:nil];
    } else if ([value isKindOfClass:[NSString class]]) {
        return [StubsResponseClass() responseWithData:[value dataUsingEncoding:NSUTF8StringEncoding] statusCode:200 headers:nil];
    } else if ([value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSArray class]]) {
        return [StubsResponseClass() responseWithJSONObject:value statusCode:200 headers:nil];
    } else if ([value isKindOfClass:[NSError class]]) {
        return [StubsResponseClass() responseWithError:value];
    } else {
        [self.mockingContext failWithReason:@"Cannot convert %@ to a OHHTTPStubsResponse", [value class]];
        return nil;
    }
}


#pragma mark - Mock Method

- (id)handleNetworkRequest:(NSURLRequest *)request {
    return nil; // return nil if not stubbed, to indicate that the request should go to the network
}

@end


#pragma mark - Getting the Network Mock

MCKNetworkMock* _mck_getNetworkMock(void) {
    return [MCKNetworkMock mockForContext:[MCKMockingContext currentContext]];
}
