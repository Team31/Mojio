//
//  ViewController.h
//  Mojio
//
//  Created by Flynn Howling on 11/14/2013.
//  Copyright (c) 2013 team31. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SpeedSelectionViewController.h"
#import "LoginViewController.h"
#import "ManageDevicesViewController.h"
#import "Session.h"
#import "Device.h"


@interface HomeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *speedSeleectionButton;
- (IBAction)SpeedSelectionButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *tripDataTextView;

- (IBAction)getTripDataButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *getUserData;
@property (weak, nonatomic) IBOutlet UITextView *userDataTextView;
- (IBAction)getUserDataButtonPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *currentSpeedLimit;


@end
