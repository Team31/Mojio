//
//  SpeedViolationDetailViewController.m
//  Mojio
//
//  Created by Flynn Howling on 2/4/2014.
//  Copyright (c) 2014 team31. All rights reserved.
//

#import "SpeedViolationDetailViewController.h"

@interface SpeedViolationDetailViewController ()

@end

@implementation SpeedViolationDetailViewController

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
    self.navigationItem.title = @"Speeding Details";

    self.speedLabel.text = self.speed;
    self.dateLabel.text = self.date;
    
    CLLocationCoordinate2D coord = {latitude: [self.latitude doubleValue], longitude: [self.longitude doubleValue]};
    MKCoordinateSpan span = {latitudeDelta: 0.01, longitudeDelta: 0.01};
    MKCoordinateRegion region = {coord, span};
    [self.mapView setRegion:region];
    MKPointAnnotation *myAnnotation = [[MKPointAnnotation alloc] init];
    myAnnotation.coordinate = CLLocationCoordinate2DMake([self.latitude doubleValue], [self.longitude doubleValue]);
    [self.mapView addAnnotation:myAnnotation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
