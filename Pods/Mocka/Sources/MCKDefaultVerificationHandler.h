//
//  MCKDefaultVerificationHandler.h
//  mocka
//
//  Created by Markus Gasser on 14.07.12.
//  Copyright (c) 2012 Markus Gasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCKVerificationHandler.h"


@interface MCKDefaultVerificationHandler : NSObject <MCKVerificationHandler>

+ (instancetype)defaultHandler;

@end
