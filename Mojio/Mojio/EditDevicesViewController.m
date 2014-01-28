//
//  EditDevicesViewController.m
//  Mojio
//
//  Created by Flynn Howling on 11/14/2013.
//  Copyright (c) 2013 team31. All rights reserved.
//

#import "EditDevicesViewController.h"


@interface EditDevicesViewController ()

@end

@implementation EditDevicesViewController

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
    
    self.navigationItem.title = @"Edit";

    self.idTextfield.text = self.device.idNumber;
    self.nicknameTextfield.text = self.device.nickname;
    self.speedLimitTextfield.text = [NSString stringWithFormat:@"%i", self.device.speedLimit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillDisappear:(BOOL)animated
{
    self.device.idNumber = self.idTextfield.text;
    self.device.nickname = self.nicknameTextfield.text;
    self.device.speedLimit = [self.speedLimitTextfield.text integerValue];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event //hide the keyboard when user tap an empty space
{
    [self.view endEditing:YES];
}
@end
