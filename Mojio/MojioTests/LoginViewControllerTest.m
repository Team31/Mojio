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
@property(nonatomic,strong) Session *session;
@end

@implementation LoginViewControllerTest
@synthesize session;

- (void)setUp
{
    [super setUp];
    self.session = [[Session alloc]init];
}

- (void)testLoginValid
{

    NSString *testUserName = @"team31";
    NSString *testPassword = @"Teamthirty1";
    
    XCTAssertTrue([self.session login:testUserName AndPassword:testPassword],@"Login with valid cred.");
}

- (void)testLoginInvalid
{
    NSString *testUserName = @"testLoginInvalid";
    NSString *testPassword = @"testLoginInvalid";
    
    XCTAssertTrue(![self.session login:testUserName AndPassword:testPassword],@"Login with invalid cred.");
}

- (void)testLoginEmpty
{
    NSString *testUserName = @"";
    NSString *testPassword = @"";
    
    XCTAssertThrows([self.session login:testUserName AndPassword:testPassword],@"Login with empty cred.");
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    self.session = nil;
    [super tearDown];
}

@end
