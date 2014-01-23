//
//  MCKSpy.h
//  mocka
//
//  Created by Markus Gasser on 21.07.12.
//  Copyright (c) 2012 Markus Gasser. All rights reserved.
//

#import <Foundation/Foundation.h>


@class MCKMockingContext;


extern id mck_createSpyForObject(id object, MCKMockingContext *context);
extern BOOL mck_objectIsSpy(id object);
