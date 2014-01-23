# Introduction

Mocka is an Objective-C mocking library designed similar to [mockito](http://code.google.com/p/mockito/). The goal is to provide a powerful yet simple and readable way to isolate your objects and test messages between objects in your unit tests.

Mocka is distributed under the [MIT License](http://opensource.org/licenses/mit-license.php). See the LICENSE file for more details.

## Features

These are some highlights of Mocka:

* **Use first, verify later** – Some mocking frameworks force you to declare your expectations before using the mocks, cluttering the test. In Mocka you use the mock first and in the end you verify your expectations, leading to a much more natural flow.
* **Readable syntax** – In addition to the clean use-then-verify approach, Mocka tries to make the syntax understandable, even if you never used it before.
* **Type safe mocks** – Mock objects in Mocka are typed and all calls done on the mocks are done on typed objects. This helps with code completion as well as renaming.
* **Type safe argument matchers** - Mocka comes with a set of argument matchers for all kinds of argument types, including structs. [OCHamcrest](https://github.com/hamcrest/OCHamcrest) matchers are supported too.
* **Support for spies** – Spies allow you to verify methods on already existing objects (sometimes called *partial mocks*). While it’s generally not a good idea to rely too strongly on this feature, it’s nonetheless useful to have it in your mocking toolbox.
* **Network Mocking** - If you include the [OHHTTPStubs](https://github.com/AliSoftware/OHHTTPStubs) library you can also stub and verify network calls using the same DSL.

# Installation

To use the library in your project you can either add it using [CocoaPods](http://cocoapods.org) or as a framework.

## CocoaPods

The easiest way is using CocoaPods. To add Mocka to your testing target add

    pod 'Mocka', '~> 0.6'

to your `Podfile` and run `pod install`.

To use Mocka in your tests include it using `#import <Mocka/Mocka.h>`.

## Mocka.framework

To use the framework either download it from the project page or build it from sources. The framework contains binaries for iOS (arm), iOS Simulator (i386) and OS X (x86_64).

To build the library execute the `MakeDistribution.sh` file in the project directory:

	$ cd /path/to/project
	$ ./MakeDistribution.sh

This will open the `Distribution/` directory in finder and give you both a .zip file and the framework ready to be copied to your project.

When you have the framework ready, simply drag it into your project and add it to your project's unit testing bundle.

After this make sure you have `-ObjC` added to your test target's `Other Linker Flags` otherwise you'll run into problems with categories not being loaded.

To use Mocka in your tests include it using `#import <Mocka/Mocka.h>`.


# Usage

This is an example of a simple test using Mocka.

	- (void)testThatGuardianCallsOperatorOnErrorCondition {
		// given
		CallCenter *callCenter = mockForClass(CallCenter);
		Guardian *guardian = [[Guardian alloc] initWithCallCenter:callCenter];
		
		// when
		[guardian errorConditionDetected];
		
		// then
		verifyCall ([callCenter callOperator]);
	}

## Creating mock objects

Use `mock(...)` to create mock objects.

	// create a mock just for a class
	NSArray *arrayMock = mock([NSArray class]);
	
	// create a mock for some protocols
	id<NSCoding, NSCopying> protocolMock = mock(@protocol(NSCoding), @protocol(NSCopying));
	
	// create a mock for a combination of a class with some protocols
	NSObject<NSCoding> *weirdMock = mock([NSObject class], @protocol(NSCoding));

Mocks can have at most one class. If the mock should mock a class it must be the first argument passed to `mock(...)`. Apart from this rule you can create arbitrary combinations, with any number of protocols.

If you just want to mock a single protocol or class there is a shortcut:

	// create a mock for just a class
	NSArray *arrayMock = mockForClass(NSArray);
	
	// create a mock for just a protocol
	id<NSCoding> codingMock = mockForProtocol(NSCoding);

Note that you don’t need to call `[Foo class]` or `@protocol(Bar)` in this case.

## Spies

To spy on an existing object you use `spy(...)`. You pass it an existing object instance which will then be turned into a mocka spy object. The returned object is the same instance as the passed one.

	Foo *foo = [[Foo alloc] init];
	Foo *fooMock = spy(foo);
	assert(foo == fooMock);

Now you can use the mock (or the original object) in any way you could use any other mock, including stubbing and verifying. Note that you cannot spy on core foundation bridging classes (all classes that start with `__NSCF`).

To see some examples for creating mocks see `Tests/ExamplesCreatingMocks.m`.

## Verifying

To verify that a certain call was made use the `verifyCall` keyword.

	// given
	NSArray *arrayMock = mockForClass(NSArray);
	
	// when
	DoSomethingWith(arrayMock);
	
	// then
	verifyCall ([arrayMock objectAtIndex:0]);

If `DoSomethingWith(...)` didn’t call `[arrayMock objectAtIndex:0]` then `verifyCall` will generate a test failure.

By default `verifyCall` will succeed if at least one matching call was made, but you can change this behavior. For example to verify an exact number of calls use `verifyCall (exactly(N) <#CALL#>)` (where `N` is the number of invocations).

	// only succeed if there were exactly 3 calls to -addObject:
	verifyCall (exactly(3) [arrayMock addObject:@"Foo"])

Note that matching calls are not evaluated again. Consider the following example:

    // given
	NSArray *arrayMock = mockForClass(NSArray);
	
	[arrayMock objectAtIndex:0];
	
	verifyCall ([arrayMock objectAtIndex:0]); // this succeeds, since the call was made
	verifyCall ([arrayMock objectAtIndex:0]); // this fails, because the previous verification
	                                      // removes the call

If there were two calls to `[arrayMock objectAtIndex:0]` the second verification would succeed now, because `verifyCall (...)` only removes the first matching invocation.

More examples can be found in `Examples/ExamplesVerify.m`.

### Ordered Verification

You can verify that a group of calls was made in a given order. This is especially useful when testing interaction with a delegate or data source.

    // given
    NSArray *arrayMock = mockForClass(NSArray);
    
    [self doSomethingWith:arrayMock];
    
    // check if the following calls were made in order
    verifyInOrder {
        [arrayMock count];
        [arrayMock objectAtIndex:0];
        [arrayMock objectAtIndex:1];
    };

Note that when checking calls in order, interleaving calls do not cause a failure. E.g. the following verification will succeed, because the tested calls were all made and in order.

    // given
    NSArray *arrayMock = mockForClass(NSArray);
    
    [arrayMock count];
    [arrayMock objectAtIndex:0];
    [arrayMock objectAtIndex:1];
    [arrayMock removeAllObjects];
    
    // check if the following calls were made in order
    verifyInOrder {
        [arrayMock count];
        [arrayMock removeAllObjects];
    };

## Stubbing

By default when a method is called on a mock it will do nothing and simply return the default value (`nil` for objects, `0` for integers, an empty struct, etc). Stubbing allows you to specify actions that should be executed when a certain method on a mock is called. To stub a method use the `stub (...) with { ... };` construct.

	NSArray *arrayMock = mockForClass(NSArray);
	
	stub ([arrayMock count]) with {
	    return 1;
	};
	
	stub ([arrayMock objectAtIndex:0]) with {
	    return @"Foo";
	};
	
	if ([arrayMock count] > 0) {
	    NSLog(@"Object in array: %@", [arrayMock objectAtIndex:0]);
	} else {
	    NSLog(@"Array is empty");
	}
	// Prints: "Object in array: Foo"

You can group multiple calls to have the same actions by using `stubAll` instead of `stub`:

	stubAll ({
	    [mock doSomething];
	    [mock doSomethingElse];
	}) with {
	    @throw [NSException exceptionWithName:@"ExceptionalException"
	                                   reason:nil
	                                 userInfo:nil];
	};

You can use the arguments passed to the stubbed call:

	stub ([mock increase:anyInt()]) with (NSUInteger i) {
	    return (i + 1);
	};

*Tip*: Add a snippet to the Xcode snippet library for `stub (...) with { ... };`

Examples about stubbing are in `Examples/ExamplesStub.m`.

## Network Mocking

You need to add the `OHHTTPStubs` library for those features to be available.

If you have it installed you can disable access to the real network using `[Network disable]`. From this point on HTTP(S) calls won't hit the network and you'll get a "No internet connection" error instead. This is useful to avoid potentially slow and unreliable internet access, instead seeing an error directly if you accidentally hit the network. To reenable it later use `[Network enable]`.

### Network Stubbing

Regardless wether the real network is enabled or not, you can define stubbed responses for specific network calls.

    stub (Network.GET(@"http://www.google.ch")) with {
        return @"Hello World";
    };

You can return any of the following types:

* `NSData` is returned exactly as is
* `NSString` is interpreted as UTF-8 data
* `NSDictionary` and `NSArray` are interpreted as JSON objects and return JSON data
* `NSError` is interpreted as a connection error
* `nil` is interpreted as not available (no internet connection)
* `OHHTTPStubsResponse` to configure exactly what you want returned


### Network Verification

You can also monitor and verify network calls.

    [Network startObservingNetworkCalls]; // needed to verify
    
    [controller reloadSomeData];
    
    verifyCall (Network.GET(@"http://my-service.com/some/resource"));


## Prefixed Syntax

Mocka does not use prefixes by default. If you experience problems because of this add `#define MCK_DISABLE_NICE_SYNTAX` before including any Mocka header.

# Alternatives to Mocka
If you don’t like my implementation or you’re just looking for alternatives, here are a few other mocking libraries I’ve used before. Maybe one of those suits your needs:

* [OCMock](https://github.com/erikdoe/ocmock) – As far as I know the most feature complete mocking library out there. It’s also the most mature mocking library I know of.
* [OCMockito](https://github.com/jonreid/OCMockito/) – An Objective-C implementation of mockito. 
* [LRMocky](https://github.com/lukeredpath/LRMocky) – An Objective-C mocking framework modeled after jMock.
