//
//  NSInputStream+ACOParsing.h
//  ACOKit
//
//  Created by Markus Gasser on 22.01.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSInputStream (ACOParsing)

- (BOOL)aco_readWord:(out uint16_t *)word error:(NSError **)error;
- (BOOL)aco_readString:(out NSString **)string error:(NSError **)error;

@end
