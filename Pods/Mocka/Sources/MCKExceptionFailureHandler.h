//
//  MCKExceptionFailureHandler.h
//  mocka
//
//  Created by Markus Gasser on 05.10.12.
//  Copyright (c) 2012 Markus Gasser. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MCKFailureHandler.h"


extern NSString * const MCKTestFailureException;
extern NSString * const MCKFileNameKey;
extern NSString * const MCKLineNumberKey;


@interface MCKExceptionFailureHandler : NSObject <MCKFailureHandler>

@end
