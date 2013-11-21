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

- (void)testLoginTapped
{
//    self.lvc.UsernameTextField = [[UITextField alloc] init];
//    self.lvc.PasswordTextField = [[UITextField alloc] init];
//    self.lvc.StatusLabel = [[UILabel alloc] init];
//    self.lvc.UsernameTextField.text = @"test";
//    self.lvc.PasswordTextField.text = @"test";
//    self.lvc.StatusLabel.text = @"test";
//    NSString *expectation = @"Username and password combination incorrect.";
//    [UIButton buttonWithType:self.lvc.LoginButton];
    //self.lvc.LoginButton = [[UIButton alloc] init];
    //[self.lvc.LoginButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    	//printf("%s",[lvc.UsernameTextField.text UTF8String]);
    //XCTAssertTrue([s	elf.lvc.StatusLabel.text isEqual:expectation], @"war");
    //XCTAssertNil(self.lvc.UsernameTextField, @"PLZ");
    //XCTAssertEqualObjects(self.lvc.StatusLabel.text, expectation, @"We should see login fails.");
    //[loginViewController LoginTapped:[loginViewController LoginButton]];
    //XCTAssertTrue([[loginViewController.StatusLabel st	);
    //XCTAssertTrue([self.lvc.StatusLabel.text isEqualToString:@"Username and password combination incorrect."], @"Lenght does not equal 0");
    NSString *testUserName = @"team31";
    NSString *testPassword = @"Teamthirty1";
    
    XCTAssertTrue([[Session sharedInstance] login:testUserName AndPassword:testPassword],@"HELP");
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

@end
