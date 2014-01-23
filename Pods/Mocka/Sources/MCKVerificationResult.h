//
//  MCKVerificationResult.h
//  mocka
//
//  Created by Markus Gasser on 30.9.2013.
//  Copyright (c) 2013 konoma GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MCKVerificationResult : NSObject

+ (instancetype)successWithMatchingIndexes:(NSIndexSet *)matches;
+ (instancetype)failureWithReason:(NSString *)reason matchingIndexes:(NSIndexSet *)matches;
- (instancetype)initWithSuccess:(BOOL)success failureReason:(NSString *)failureReason matchingIndexes:(NSIndexSet *)matches;

@property (nonatomic, readonly, getter = isSuccess) BOOL success;
@property (nonatomic, readonly) NSString *failureReason;
@property (nonatomic, readonly) NSIndexSet *matchingIndexes;

@end
