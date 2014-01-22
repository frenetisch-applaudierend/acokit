//
//  ACOKit.h
//  ACOKit
//
//  Created by Markus Gasser on 22.01.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TargetConditionals.h>


#import "ACOColorSwatch.h"
#import "ACOColorEntry.h"

#ifdef TARGET_OS_IPHONE
    #import "ACOColorSwatch+UIKit.h"
#else
    #import "ACOColorSwatch+AppKit.h"
#endif
