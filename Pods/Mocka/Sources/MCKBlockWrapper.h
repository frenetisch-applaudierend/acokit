//
//  MCKBlockWrapper.h
//  mocka
//
//  Created by Markus Gasser on 2.11.2013.
//  Copyright (c) 2013 konoma GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MCKBlockWrapper : NSObject

#pragma mark - Initialization

+ (instancetype)wrapperForBlock:(id)block;
- (instancetype)initWithBlock:(id)block;


#pragma mark - Get Block Information

@property (nonatomic, readonly) id block;
@property (nonatomic, readonly) NSMethodSignature *blockSignature;

// accounts for the implicit param, otherwise exactly as the NSMethodSignature version
- (const char *)getParameterTypeAtIndex:(NSUInteger)index;


#pragma mark - Invoking the Block

// Parameters are 0 based. The block is passed implicitely and not counted.
// E.g. ^(int i, int j) {} has 2 parameters, i=0 and j=1
// Otherwise equivalent to -[NSInvocation setArgument:atIndex:]
- (void)setParameter:(void *)parameter atIndex:(NSUInteger)index;

// Equivalent to -[NSInvocation getReturnValue:]
- (void)getReturnValue:(void *)returnValue;

- (void)invoke;

@end
