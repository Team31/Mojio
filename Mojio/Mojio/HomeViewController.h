//
//  ViewController.h
//  Mojio
//
//  Created by Flynn Howling on 11/14/2013.
//  Copyright (c) 2013 team31. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *speedSeleectionButton;

- (IBAction)SpeedSelectionButtonPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *LoginButton;
- (IBAction)LoginTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *manageDeviceButton;
- (IBAction)manageDeviceButton:(id)sender;

@end
