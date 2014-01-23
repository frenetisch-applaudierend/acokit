//
//  MCKNetworkRequestMatcher.h
//  mocka
//
//  Created by Markus Gasser on 26.10.2013.
//  Copyright (c) 2013 konoma GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MCKArgumentMatcher.h"


@interface MCKNetworkRequestMatcher : NSObject <MCKArgumentMatcher>

+ (instancetype)matcherForURL:(NSURL *)url HTTPMethod:(NSString *)method;

@property (nonatomic, readonly) NSURL *URL;
@property (nonatomic, readonly) NSString *HTTPMethod;

@end
