//
//  LoginViewController.m
//  Mojio
//
//  Created by Flynn Howling on 11/14/2013.
//  Copyright (c) 2013 team31. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@property (nonatomic,strong) MojioClient* client;

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
    self.client = [[MojioClient alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)LoginTapped:(id)sender {
    if (self.UsernameTextField.text.length != 0) {
        if ([self.client setUserWithUsername:@"team31" AndPassword:@"Teamthirty1"]){
            self.StatusLabel.text = @"Login successful";
        } else {
            self.StatusLabel.text = @"Username and password combination incorrect.";
        }
    } else {
        self.StatusLabel.text = @"No valid username input";
    }
}
@end
