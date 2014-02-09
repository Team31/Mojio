//
//  LoginViewController.m
//  Mojio
//
//  Created by Flynn Howling on 11/14/2013.
//  Copyright (c) 2013 team31. All rights reserved.
//

#import "LoginViewController.h"
#import "HomeViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //self.navigationItem.hidesBackButton = YES;
    self.navigationItem.title = @"Login";
    
    if ([[[Session sharedInstance] client] isUserLoggedIn]) {
        self.StatusLabel.text = @"You are already logged in";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registerButtonPressed:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://sandbox.developer.moj.io/Account/register"]];
}

- (IBAction)LoginTapped:(id)sender {
    if (self.UsernameTextField.text.length > 0 && self.PasswordTextField.text.length > 0) {
        if ([[Session sharedInstance] login:self.UsernameTextField.text AndPassword:self.PasswordTextField.text]){
            self.StatusLabel.text = @"Login successful";
            
            // redirect to homepage
            [[self navigationController] popViewControllerAnimated:YES];
        } else {
            self.StatusLabel.text = @"Invalid password or username";
        }
    } else {
        self.StatusLabel.text = @"No valid username or password input";
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
