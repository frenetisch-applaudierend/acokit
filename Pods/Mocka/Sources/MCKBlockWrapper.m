//
//  MCKBlockWrapper.m
//  mocka
//
//  Created by Markus Gasser on 2.11.2013.
//  Copyright (c) 2013 konoma GmbH. All rights reserved.
//
//  Implementation is based on Mike Ash's MABlockForwarding https://github.com/mikeash/MABlockForwarding/
//  Additional information:
//   http://www.mikeash.com/pyblog/friday-qa-2011-10-28-generic-block-proxying.html
//   http://www.cocoawithlove.com/2009/10/how-blocks-are-implemented-and.html
//   http://clang.llvm.org/docs/Block-ABI-Apple.html
//

#import "MCKBlockWrapper.h"


@interface NSInvocation (MCKPrivate)

- (void)invokeUsingIMP:(IMP)imp;

@end

struct BlockDescriptor {
    unsigned long reserved;
    unsigned long size;
    void *rest[1];
};

struct Block {
    void *isa;
    int flags;
    int reserved;
    void *invoke;
    struct BlockDescriptor *descriptor;
};

enum {
    BLOCK_HAS_COPY_DISPOSE =  (1 << 25),
    BLOCK_HAS_CTOR =          (1 << 26), // helpers have C++ code
    BLOCK_IS_GLOBAL =         (1 << 28),
    BLOCK_HAS_STRET =         (1 << 29), // IFF BLOCK_HAS_SIGNATURE
    BLOCK_HAS_SIGNATURE =     (1 << 30),
};

static void *BlockImpl(id block) {
    return ((__bridge struct Block *)block)->invoke;
}

static const char *BlockSig(id blockObj) {
    struct Block *block = (__bridge void *)blockObj;
    struct BlockDescriptor *descriptor = block->descriptor;
    
    assert(block->flags & BLOCK_HAS_SIGNATURE);
    
    int index = 0;
    if(block->flags & BLOCK_HAS_COPY_DISPOSE)
        index += 2;
    
    return descriptor->rest[index];
}


#pragma mark -

@interface MCKBlockWrapper ()

@property (nonatomic, readonly) NSInvocation *blockInvocation;

@end

@implementation MCKBlockWrapper

#pragma mark - Initialization

+ (instancetype)wrapperForBlock:(id)block {
    return [[self alloc] initWithBlock:block];
}

- (instancetype)initWithBlock:(id)block {
    NSParameterAssert(block != nil);
    
    if ((self = [super init])) {
        _block = [block copy];
        
        NSMethodSignature *signature = [NSMethodSignature signatureWithObjCTypes:BlockSig(block)];
        _blockInvocation = [NSInvocation invocationWithMethodSignature:signature];
        [_blockInvocation setArgument:&block atIndex:0]; // the block is the implicit first argument
        [_blockInvocation retainArguments];
    }
    return self;
}


#pragma mark - Get Block Information

- (NSMethodSignature *)blockSignature {
    return self.blockInvocation.methodSignature;
}

- (const char *)getParameterTypeAtIndex:(NSUInteger)index {
    return [self.blockSignature getArgumentTypeAtIndex:(index + 1)];
}


#pragma mark - Invoking the Block

- (void)setParameter:(void *)parameter atIndex:(NSUInteger)index {
    [self.blockInvocation setArgument:parameter atIndex:(index + 1)]; // add +1 for the implicit block arg
}

- (void)getReturnValue:(void *)returnValue {
    [self.blockInvocation getReturnValue:returnValue];
}

- (void)invoke {
    [self.blockInvocation invokeUsingIMP:BlockImpl(self.block)];
}

@end
