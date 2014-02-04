//
//  SpeedViolationDetailViewController.h
//  Mojio
//
//  Created by Flynn Howling on 2/4/2014.
//  Copyright (c) 2014 team31. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface SpeedViolationDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *speedLabel;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *speed;


@end
