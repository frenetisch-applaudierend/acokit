//
//  MCKXCTestFailureHandler.h
//  mocka
//
//  Created by Markus Gasser on 27.9.2013.
//
//

#import <Foundation/Foundation.h>

#import "MCKFailureHandler.h"



@interface MCKXCTestFailureHandler : NSObject <MCKFailureHandler>

- (instancetype)initWithTestCase:(id)testCase;

@property (nonatomic, readonly) id testCase;

@end
