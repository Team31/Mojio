//
//  ViewController.h
//  Mojio
//
//  Created by Flynn Howling on 11/14/2013.
//  Copyright (c) 2013 team31. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SpeedSelectionViewController.h"
#import "SpeedViolationViewController.h"
#import "LoginViewController.h"
#import "ManageDevicesViewController.h"
#import "Session.h"
#import "Device.h"


@interface HomeViewController : UIViewController
<MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@property (weak, nonatomic) IBOutlet UIButton *speedSeleectionButton;
- (IBAction)SpeedSelectionButtonPressed:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *currentSpeedLimit;
- (IBAction)speedViolationsButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *speedViolationButton;


@end
