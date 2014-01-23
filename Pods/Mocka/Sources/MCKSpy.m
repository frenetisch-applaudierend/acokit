//
//  MCKSpy.m
//  mocka
//
//  Created by Markus Gasser on 21.07.12.
//  Copyright (c) 2012 Markus Gasser. All rights reserved.
//

#import "MCKSpy.h"
#import "MCKMockingContext.h"
#import "MCKInvocationStubber.h"

#import <objc/runtime.h>


static NSString * const MCKSpyClassSuffix = @"{MockaSpy}";
static NSString * const MCKSpyBackupMethodPrefix = @"_mck_backup_";

static const NSUInteger MCKContextKey;

static void mck_convertObjectToSpy(id object, MCKMockingContext *context);
static void mck_overrideMethodsForClass(Class cls, Class spyClass, MCKMockingContext *context);
static void mck_overrideMethodsForConcreteClass(Class cls, Class spyClass, NSMutableSet *overriddenMethods, MCKMockingContext *context);
static SEL mck_backupSelectorForSelector(SEL selector);

static Class spy_class(id self, SEL _cmd);
static void spy_forwardInvocation(id self, SEL _cmd, NSInvocation *invocation);
static NSString* spy_descriptionWithLocale(id self, SEL _cmd, NSLocale *locale);
static NSString* spy_description(id self, SEL _cmd);


#pragma mark -
@interface NSObject (MCKUnhandledMethod)
- (void)mck_methodThatDoesNotExist;
@end


#pragma mark - Creating a Spy

id mck_createSpyForObject(id object, MCKMockingContext *context) {
    // don't spy a spy
    if (mck_objectIsSpy(object)) {
        return object;
    }
    
    // safeguards
    if (object == nil) {
        [context failWithReason:@"You cannot spy nil"];
        return nil;
    } else if ([NSStringFromClass(object_getClass(object)) hasPrefix:@"__NSCF"]) {
        [context failWithReason:@"Cannot spy an instance of a core foundation class (%@)", object_getClass(object)];
        return nil;
    }
    
    mck_convertObjectToSpy(object, context);
    objc_setAssociatedObject(object, &MCKContextKey, context, OBJC_ASSOCIATION_ASSIGN); // weak
    return object;
}

static void mck_convertObjectToSpy(id object, MCKMockingContext *context) {
#define overrideMethod(cls, sel, imp) class_addMethod((cls), (sel), (IMP)&(imp), method_getTypeEncoding(class_getInstanceMethod(cls, (sel))))
    
    Class originalClass = object_getClass(object);
    const char *spyClassName = [[NSStringFromClass(originalClass) stringByAppendingString:MCKSpyClassSuffix] UTF8String];
    Class spyClass = objc_getClass(spyClassName);
    if (spyClass == Nil) {
        spyClass = objc_allocateClassPair(originalClass, spyClassName, 0);
        overrideMethod(spyClass, @selector(class),                  spy_class);
        overrideMethod(spyClass, @selector(forwardInvocation:),     spy_forwardInvocation);
        
        if ([object respondsToSelector:@selector(descriptionWithLocale:)]) {
            overrideMethod(spyClass, @selector(descriptionWithLocale:), spy_descriptionWithLocale);
        } else {
            overrideMethod(spyClass, @selector(description), spy_description);
        }
        
        mck_overrideMethodsForClass(originalClass, spyClass, context);
        objc_registerClassPair(spyClass);
    }
    object_setClass(object, spyClass);
}

static void mck_overrideMethodsForClass(Class cls, Class spyClass, MCKMockingContext *context) {
    Class nsobjectClass = objc_getClass("NSObject");
    Class nsproxyClass = objc_getClass("NSProxy");
    Class currentClass = cls;
    NSMutableSet *overriddenMethods = [NSMutableSet set];
    while (currentClass != Nil && currentClass != nsobjectClass && currentClass != nsproxyClass) {
        mck_overrideMethodsForConcreteClass(currentClass, spyClass, overriddenMethods, context);
        currentClass = class_getSuperclass(currentClass);
    }
}

static void mck_overrideMethodsForConcreteClass(Class cls, Class spyClass, NSMutableSet *overriddenMethods, MCKMockingContext *context) {
    // There are some potentially dangerous methods to override, we explicitely forbid those
    NSArray *forbiddenMethods = @[
        @"retain", @"release", @"autorelease", @"retainCount",
        @"methodSignatureForSelector:", @"respondsToSelector:", @"forwardInvocation:",
        @"class", @"descriptionWithLocale:", @"description"
    ];
    IMP forwarder = class_getMethodImplementation(cls, @selector(mck_methodThatDoesNotExist));
    
    unsigned int numMethods = 0;
    Method *methods = class_copyMethodList(cls, &numMethods);
    for (unsigned int i = 0; i < numMethods; i++) {
        NSString *methodName = NSStringFromSelector(method_getName(methods[i]));
        // Check if there is a reason not to override this method, e.g. it was already overridden or it belongs to the "evil" methods
        if ([forbiddenMethods containsObject:methodName] || [overriddenMethods containsObject:methodName] || [methodName hasPrefix:@"_"]) {
            continue;
        }
        
        // Backup the original method for later access and override it
        IMP backup = method_getImplementation(methods[i]);
        SEL backupSelector = mck_backupSelectorForSelector(method_getName(methods[i]));
        BOOL success = class_addMethod(spyClass, backupSelector, backup, method_getTypeEncoding(methods[i]));
        success &= class_addMethod(spyClass, method_getName(methods[i]), forwarder, method_getTypeEncoding(methods[i]));
        if (!success) {
            [context failWithReason:@"Error overriding method %@", NSStringFromSelector(method_getName(methods[i]))];
        }
        
        [overriddenMethods addObject:NSStringFromSelector(method_getName(methods[i]))];
    }
    free(methods);
    
}

static SEL mck_backupSelectorForSelector(SEL selector) {
    return NSSelectorFromString([MCKSpyBackupMethodPrefix stringByAppendingString:NSStringFromSelector(selector)]);
}


#pragma mark - Testing if an object is a Spy

BOOL mck_objectIsSpy(id object) {
    return (object != nil && [NSStringFromClass(object_getClass(object)) hasSuffix:MCKSpyClassSuffix]);
}


#pragma mark - Methods to override in Spies

static Class spy_class(id self, SEL _cmd) {
    return class_getSuperclass(object_getClass(self));
}

static void spy_forwardInvocation(id self, SEL _cmd, NSInvocation *invocation) {
    MCKMockingContext *context = objc_getAssociatedObject(self, &MCKContextKey);
    
    // In recording mode we want the original method to be called; unless it's stubbed in which case the stub takes over
    if (context.mode == MCKContextModeRecording && ![context.invocationStubber hasStubsRecordedForInvocation:invocation]) {
        // Exchange our overridden method with the backup one to call through the original
        // Why not just change the selector on the invocation? Because we want to retain
        // the original selector, in case the original method relies on this.
        Method overridden = class_getInstanceMethod(object_getClass(self), invocation.selector);
        Method backup = class_getInstanceMethod(object_getClass(self), mck_backupSelectorForSelector(invocation.selector));
        method_exchangeImplementations(overridden, backup);
        [invocation invoke]; // will now invoke the backup method
        method_exchangeImplementations(backup, overridden);
    }
    
    // Now pass the invocation to the context for stubbing, recording, verifying...
    [context handleInvocation:invocation];
}

static NSString* spy_descriptionWithLocale(id self, SEL _cmd, NSLocale *locale) {
    return spy_description(self, _cmd);
}

static NSString* spy_description(id self, SEL _cmd) {
    return [NSString stringWithFormat:@"<spy{%@}: %p>", class_getSuperclass(object_getClass(self)), self];
}
