//
//  MCKNetworkMock.h
//  mocka
//
//  Created by Markus Gasser on 26.10.2013.
//  Copyright (c) 2013 konoma GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MCKNetworkMock;
@class MCKNetworkRequestMatcher;
@class MCKMockingContext;

typedef MCKNetworkRequestMatcher*(^MCKNetworkActivity)(id url);


@interface MCKNetworkMock : NSObject

#pragma mark - Initialization

- (instancetype)initWithMockingContext:(MCKMockingContext *)context;


#pragma mark - Network Control

@property (nonatomic, readonly, getter = isEnabled) BOOL enabled;

- (void)disable;
- (void)enable;
- (void)startObservingNetworkCalls;


#pragma mark - Stubbing and Verification DSL

@property (nonatomic, readonly) MCKNetworkActivity GET;
@property (nonatomic, readonly) MCKNetworkActivity PUT;
@property (nonatomic, readonly) MCKNetworkActivity POST;
@property (nonatomic, readonly) MCKNetworkActivity DELETE;

@end


#define MCKNetwork (id)_mck_getNetworkMock()
#ifndef MCK_DISABLE_NICE_SYNTAX
    #define Network MCKNetwork
#endif
extern MCKNetworkMock* _mck_getNetworkMock(void);
