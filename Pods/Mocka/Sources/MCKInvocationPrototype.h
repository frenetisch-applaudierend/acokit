//
//  MCKInvocationPrototype.h
//  mocka
//
//  Created by Markus Gasser on 27.9.2013.
//
//

#import <Foundation/Foundation.h>


@interface MCKInvocationPrototype : NSObject

#pragma mark - Initialization

- (instancetype)initWithInvocation:(NSInvocation *)invocation argumentMatchers:(NSArray *)argumentMatchers;
- (instancetype)initWithInvocation:(NSInvocation *)invocation;


#pragma mark - Getting Prototype Infos

@property (nonatomic, readonly) NSInvocation *invocation;
@property (nonatomic, readonly) NSArray *argumentMatchers; // ordered and completed argument matchers
@property (nonatomic, readonly) NSString *methodName;


#pragma mark - Matching Invocations

/**
 * Checks if the prototypes invocation and matchers can match the given invocation candidate.
 *
 * A prototype matches a candidate if the target and selectors match (==) and the arguments are
 * either equal or (if the prototype has argument matchers) all arguments can be matched.
 *
 * Two arguments are considered equal if -isEqual: (for objects) or the == operator return YES.
 */
- (BOOL)matchesInvocation:(NSInvocation *)candidate;

@end
