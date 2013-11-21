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
//@property(nonatomic, strong) LoginViewController *lvc;
@end

@implementation LoginViewControllerTest
//@synthesize lvc;

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    //self.lvc = [[LoginViewController alloc] init];
    //[lvc view];
}




//- (void)testLogin
//{
//    LoginViewController *loginViewController = [[LoginViewController alloc] init];
//    XCTAssertEqual(loginViewController.UsernameTextField.text.length, 0U, @"Lenght does not equal 0");
//    //XCTAssertEqual(loginViewController.UsernameTextField.text.length, 1U, @"Lenght does not equal 1");
//}
//
//- (void)test
//{
//    LoginViewController *loginViewController = [[LoginViewController alloc] init];
//    XCTAssertEqual(loginViewController.UsernameTextField.text.length, 0U, @"Lenght does not equal 0");
//    //XCTAssertEqual(loginViewController.UsernameTextField.text.length, 1U, @"Lenght does not equal 1");
//}

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
