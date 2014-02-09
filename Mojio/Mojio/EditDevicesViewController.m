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
    
    //get dict containing all the device data to store to Mojio server
    NSDictionary *mojioData = [[NSMutableDictionary alloc] init];
    mojioData = [self.device createMojioDictionary];
    
    // send a request to mojio server to update the value
    if (![[[Session sharedInstance] client] storeMojio:self.device.idNumber andKey:@"deviceData" andValue:mojioData]) {
        NSLog(@"An error occurred during storing");
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event //hide the keyboard when user tap an empty space
{
    [self.view endEditing:YES];
}
@end
