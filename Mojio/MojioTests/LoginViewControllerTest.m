//
//  MojioTests.m
//  MojioTests
//
//  Created by Flynn Howling on 11/14/2013.
//  Copyright (c) 2013 team31. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LoginViewController.h"

@interface LoginViewControllerTest : XCTestCase
@end

@implementation LoginViewControllerTest


- (void)setUp
{
    [super setUp];
}

- (void)testLoginValid
{

    NSString *testUserName = @"team31";
    NSString *testPassword = @"Teamthirty1";
    
    XCTAssertTrue([[Session sharedInstance] login:testUserName AndPassword:testPassword],@"Login with valid cred.");
}

- (void)testLoginInvalid
{
    NSString *testUserName = @"test";
    NSString *testPassword = @"test";
    
    XCTAssertTrue(![[Session sharedInstance] login:testUserName AndPassword:testPassword],@"Login with invalid cred.");
}

- (void)testLoginEmpty
{
    NSString *testUserName = @"";
    NSString *testPassword = @"";
    
    XCTAssertThrows([[Session sharedInstance] login:testUserName AndPassword:testPassword],@"Login with empty cred.");
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

@end
