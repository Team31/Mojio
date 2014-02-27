//
//  EditDevicesViewController.h
//  Mojio
//
//  Created by Flynn Howling on 11/14/2013.
//  Copyright (c) 2013 team31. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Device.h"
#import "Session.h"

@interface EditDevicesViewController : UIViewController

@property int currentDeviceIndex;

@property (weak, nonatomic) Device *device;
@property (weak, nonatomic) IBOutlet UITextField *idTextfield;
@property (weak, nonatomic) IBOutlet UITextField *nicknameTextfield;
@property (weak, nonatomic) IBOutlet UITextField *speedLimitTextfield;

@property (strong, nonatomic) IBOutlet UIButton *saveChanges;
@property (strong, nonatomic) IBOutlet UIButton *setActiveDevice;
- (IBAction)setActiveDeviceTapped:(id)sender;
- (IBAction)saveChangesTapped:(id)sender;

@end
