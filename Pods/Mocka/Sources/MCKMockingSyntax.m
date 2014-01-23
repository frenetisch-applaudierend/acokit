//
//  MCKMockingSyntax.m
//  mocka
//
//  Created by Markus Gasser on 25.9.2013.
//
//

#import "MCKMockingSyntax.h"

#import "MCKMockingContext.h"
#import "MCKMockObject.h"
#import "MCKSpy.h"


id _mck_createMock(MCKLocation *location, NSArray *classAndProtocols) {
    MCKMockingContext *context = [MCKMockingContext currentContext];
    context.currentLocation = location;
    return [MCKMockObject mockWithContext:context classAndProtocols:classAndProtocols];
}

id _mck_createSpy(MCKLocation *location, id object) {
    MCKMockingContext *context = [MCKMockingContext currentContext];
    context.currentLocation = location;
    return mck_createSpyForObject(object, context);
}
