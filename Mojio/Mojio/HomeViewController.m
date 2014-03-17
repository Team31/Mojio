//
//  HomeViewController.m
//  Mojio
//
//  Created by Flynn Howling on 11/14/2013.
//  Copyright (c) 2013 team31. All rights reserved.
//

#import "HomeViewController.h"
#import "Reachability.h"

Device* currentDevice;

@interface HomeViewController ()
{
    Reachability *internetReachableFoo;
}
@property (strong, nonatomic) UIStoryboard *storyBoard;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.firstTimer = false;
    //set the navigtion bar left and right buttons
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Devices" style:UIBarButtonItemStylePlain target:self action:@selector(manageDevicesTapped)];
    
    //get main storyboard, we will instantiate viewControllers from this
    self.storyBoard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    [self testInternetConnection];
    
    //Map stuff
   // self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 67, 320, 245)];
   // [self.view addSubview:self.mapView];
   
    
    //set userdefaults
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"lastCheckedTimestamp"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"lastCheckedTimestamp"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"speedViolations"])
    {
        NSArray *array = [[NSArray alloc] init];
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"speedViolations"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    if (![[NSUserDefaults standardUserDefaults] doubleForKey:@"lastLatitude"])
    {
        [[NSUserDefaults standardUserDefaults] setDouble:49.25 forKey:@"lastLatitude"];
        [[NSUserDefaults standardUserDefaults] setDouble:-123.2 forKey:@"lastLongitude"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    [self updateMap];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:22.0f/255.0f green:148.0f/255.0f blue:247.0f/255.0f alpha:1.0f];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
   [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    //Start timer for checking new data
    self.timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self
                                                    selector:@selector(checkTripData) userInfo:nil repeats:YES];
    
    //update UI for diff screen sizes
    if (self.view.frame.size.height == 480) {
        //3.5 inch screen
        CGRect frame = [self.mapView frame];
        frame.origin.y += 70;  // change the location
        [self.mapView setFrame:frame];
        
    }
    else
    {
        //4 inch screen or other
        CGRect frame = [self.speedViolationButton frame];
        frame.origin.y += 40;  // change the location
        [self.speedViolationButton setFrame:frame];
        
        CGRect frame2 = [self.speedSeleectionButton frame];
        frame2.origin.y += 40;  // change the location
        [self.speedSeleectionButton setFrame:frame2];
        
        CGRect frame3 = [self.currentSpeedLimit frame];
        frame3.origin.y += 40;  // change the location
        [self.currentSpeedLimit setFrame:frame3];
    }

}

-(void)viewWillAppear:(BOOL)animated
{
    [self attemptUserLogin];
    
    if ([[[Session sharedInstance] client] isUserLoggedIn]) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"LogOut" style:UIBarButtonItemStylePlain target:self action:@selector(loginTapped)];
    }
    else{
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStylePlain target:self action:@selector(loginTapped)];
    }


    NSInteger currentDeviceindex = [[[Session sharedInstance] currentUser] currentDeviceIndex];
    //make home page title the first device nickname, if it exists
    if (((Device*)[[[[Session sharedInstance] currentUser] devices] objectAtIndex:currentDeviceindex]))
    {
        // set current device to the first device
        self.navigationItem.title = ((Device*)[[[[Session sharedInstance] currentUser] devices] objectAtIndex:currentDeviceindex]).nickname;
        NSInteger currentDeviceindex = [[[Session sharedInstance] currentUser] currentDeviceIndex];
        currentDevice = ((Device*)[[[[Session sharedInstance] currentUser] devices] objectAtIndex:currentDeviceindex]);
        self.currentSpeedLimit.text = [NSString stringWithFormat:@"%i",currentDevice.speedLimit];
    }
    else
    {
        self.navigationItem.title = @"Home";
    }
    
    //If the user is not logged in, present the login screen
    if (![[[Session sharedInstance] client] isUserLoggedIn]) {
        UIViewController *loginViewController = (LoginViewController *)[self.storyBoard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self.navigationController pushViewController:loginViewController animated:true];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)updateMap
{
    double lastLatitude = [[NSUserDefaults standardUserDefaults] doubleForKey:@"lastLatitude"];
    double lastLongitude = [[NSUserDefaults standardUserDefaults] doubleForKey:@"lastLongitude"];
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    CLLocationCoordinate2D coord = {latitude: lastLatitude, longitude: lastLongitude};
    MKCoordinateSpan span = {latitudeDelta: 0.01, longitudeDelta: 0.01};
    MKCoordinateRegion region = {coord, span};
    [self.mapView setRegion:region];
    MKPointAnnotation *myAnnotation = [[MKPointAnnotation alloc] init];
    myAnnotation.coordinate = CLLocationCoordinate2DMake(lastLatitude, lastLongitude);
    [self.mapView addAnnotation:myAnnotation];

    
}

- (IBAction)SpeedSelectionButtonPressed:(id)sender {
    UIViewController *speedSelectionViewController = (SpeedSelectionViewController *)[self.storyBoard instantiateViewControllerWithIdentifier:@"SpeedSelectionViewController"];
    [self.navigationController pushViewController:speedSelectionViewController animated:true];
}

- (void)loginTapped{
    if ([[[Session sharedInstance] client] isUserLoggedIn]) {
        //logout user
        [[Session sharedInstance] logoutCurrentUser];
    }
    UIViewController *loginViewController = (LoginViewController *)[self.storyBoard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self.navigationController pushViewController:loginViewController animated:true];
}

- (void)manageDevicesTapped {
    UIViewController *manageDevicesViewController = (ManageDevicesViewController *)[self.storyBoard instantiateViewControllerWithIdentifier:@"ManageDevicesViewController"];
    [self.navigationController pushViewController:manageDevicesViewController animated:true];
}

- (void)populateDeviceData{
    // store relevant device data
    NSMutableArray* deviceList = [[NSMutableArray alloc] init];
    
    // device data returned from Mojio server
    NSMutableArray* deviceDataReturned = [[[[Session sharedInstance] client] getDevices] objectForKey:@"Data"];
    
    for (NSMutableDictionary *deviceData in deviceDataReturned) {
        // define each device: idNumber, speedLimit, onOff and nickname
        Device *device = [[Device alloc] init];
        [device setIdNumber:[deviceData objectForKey:@"_id"]];
        
        if( [device setDeviceData] == false || [device.nickname length] == 0) {
            [device setNickname:[deviceData objectForKey:@"Name"]];
        }
        
        // and add it to deviceList
        [deviceList addObject:device];
    }
    User *userOne = [[User alloc] init];
    [userOne setUsername:@"TestUserName"];
    [userOne setDevices:deviceList];
    //start session singleton
    [[Session sharedInstance] setCurrentUser:userOne];
    
    //refresh the homepage title for the new device downloaded
    [self viewDidAppear:true];
    
}

- (void)attemptUserLogin{
    //if a current user is already defined, no need to attempt user login
    if ([[Session sharedInstance] currentUser]) {
        return;
    }
    //get APItoken from NSUserdefaults
    //set the client with that token
    //try to get user data
    NSString *apiToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"apiToken"];
    [[[Session sharedInstance] client] setApiToken:apiToken];
    
    if ([[[Session sharedInstance] client] isUserLoggedIn]) {
        [self populateDeviceData];
    }
    return;
}


- (void)checkTripData {
    if (!self.firstTimer) {
        //do not check immediately, start checking after 10 sec
        //this was background fetch has a chance to calculate
        self.firstTimer = true;
        return;
    }

    //alert user of speeding
    if ([self hasSpeedingOcurred]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Speeding Alert"
                                                        message:@"Speeding has ocurred"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];

    }
    [self updateMap];
}


-(BOOL) hasSpeedingOcurred
{
    NSLog(@"check for speeding");
    /*
     get last trip ID
     get events for last trip
     calculate speed between each event
     if speed > threshold then alert user of speed and time, maybe location
     */
    
    //get the trips
    NSMutableArray* tripData = [[[[Session sharedInstance] client] getTripData] objectForKey:@"Data"];
    if ([tripData count] < 1) {
       // self.tripDataTextView.text = @"No trip data";
        return false;
    }
    //get the ID for the most recent trip
    NSString* tripIDString = [((NSMutableDictionary*)[tripData objectAtIndex:[tripData count]-1]) objectForKey:@"_id"];
    
    //get the events for that most recent trip
    NSMutableDictionary* tripEvents = [[[Session sharedInstance] client] getEventDataForTrip:tripIDString];
    NSMutableArray* tripEventsArray = [tripEvents objectForKey:@"Data"];
    //TODO: is this gaurunteed to be in order?
    
    //get Current Deivce speed limit
    NSInteger currentDeviceindex = [[Session sharedInstance] currentUser].currentDeviceIndex;
    currentDevice = ((Device*)[[[[Session sharedInstance] currentUser] devices] objectAtIndex:currentDeviceindex]);
    
    NSInteger deviceSpeedLimit = currentDevice.speedLimit;
    if (!currentDevice.onOff) {
        //if the device is off the limit should not be used
        deviceSpeedLimit = 100000;
    }
    
    //go through each event and calculate the speed between each event
    //based on the timestamp and location
    NSMutableDictionary* previousEvent = [[NSMutableDictionary alloc] init];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSTimeInterval differenceInTime;
    CLLocationDistance distance;
    double speed, exceededSpeed = 0;
    //save the last event date, so you can start from there next time
    NSDate *lastEventDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastCheckedTimestamp"];
    
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    
    //Save values for speed Violation list
    NSMutableDictionary *violationDict = [[NSMutableDictionary alloc] init];
    
    for (NSMutableDictionary *event in tripEventsArray) {
        
        if ([previousEvent objectForKey:@"Location"] && [event objectForKey:@"Location"]) {
            //convert string to time and get the difference between events
            NSDate *eventDate = [dateFormat dateFromString:[event objectForKey:@"Time"]];
            
            //is the eventDate later in time than the last timestamp?
            if ([eventDate compare:lastEventDate] == NSOrderedDescending) {

                NSDate *previousEventDate = [dateFormat dateFromString:[previousEvent objectForKey:@"Time"]];
                differenceInTime = [eventDate timeIntervalSinceDate:previousEventDate];
                lastEventDate = eventDate;
                
                
                    //get locations and find distance between events
                    CLLocationDegrees previousLat = [[[previousEvent objectForKey:@"Location"] objectForKey:@"Lat"] doubleValue];
                    CLLocationDegrees previousLong =[[[previousEvent objectForKey:@"Location"] objectForKey:@"Lng"] doubleValue];
                
               
                    
                    CLLocationDegrees eventLat =[[[event objectForKey:@"Location"] objectForKey:@"Lat"] doubleValue];
                    CLLocationDegrees eventLong =[[[event objectForKey:@"Location"] objectForKey:@"Lng"] doubleValue];
                    
                    CLLocation *locA = [[CLLocation alloc] initWithLatitude:previousLat longitude:previousLong];
                    CLLocation *locB = [[CLLocation alloc] initWithLatitude:eventLat longitude:eventLong];
                    //distance is in meters
                    distance = [locA distanceFromLocation:locB];
                    speed =(distance/differenceInTime)*3.6; //m/s to km/h
                    
                    //save location
                    [[NSUserDefaults standardUserDefaults] setDouble:eventLat forKey:@"lastLatitude"];
                    [[NSUserDefaults standardUserDefaults] setDouble:eventLong forKey:@"lastLongitude"];
                    
                    //output for testing
                    NSLog([NSString stringWithFormat:@"Speed: %f", speed]);
                    NSLog([NSString stringWithFormat:@"Distance: %f", distance]);
                    NSLog([NSString stringWithFormat:@"%@",eventDate]);
                    


                    //calculate speed between events
                    //make sure distance isn't an error
                    if (distance < 1000) {
                        //just grab the last speeding speed for now to alert the user
                        
                        if (speed > deviceSpeedLimit) {
                            exceededSpeed = speed;
                            [violationDict setObject:[dateFormat stringFromDate:eventDate] forKey:@"Date"];
                            [violationDict setObject:[NSString stringWithFormat:@"%.f",speed] forKey:@"Speed"];
                            [violationDict setObject:[NSString stringWithFormat:@"%f",eventLat] forKey:@"Latitude"];
                            [violationDict setObject:[NSString stringWithFormat:@"%f",eventLong] forKey:@"Longitude"];
                            //don't give another alert for at least 60 seconds
                            lastEventDate = [lastEventDate dateByAddingTimeInterval:60];
                        }
                        
                    }
                
            }//is date after last timestamp
        }
        previousEvent = event;
    }
    
    //save the last date from the trip
    [[NSUserDefaults standardUserDefaults] setObject:lastEventDate forKey:@"lastCheckedTimestamp"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    

    if (exceededSpeed > 0) {
        NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"speedViolations"]];
        [mutableArray addObject:violationDict];
        NSArray *array = [NSArray arrayWithArray:mutableArray];
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"speedViolations"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        
        return true;
    }
    return false;

}

- (void)testInternetConnection
{
    internetReachableFoo = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    // Internet is reachable
    internetReachableFoo.reachableBlock = ^(Reachability*reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Internet Accessible");
        });
    };
    
    // Internet is not reachable
    internetReachableFoo.unreachableBlock = ^(Reachability*reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"No internet access");
        });
    };
    
    [internetReachableFoo startNotifier];
}
- (IBAction)speedViolationsButtonPressed:(id)sender {
    UIViewController *speedViolationViewController = (SpeedViolationViewController *)[self.storyBoard instantiateViewControllerWithIdentifier:@"SpeedViolationViewController"];
    [self.navigationController pushViewController:speedViolationViewController animated:true];
}


#pragma mark MapView

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    id <MKAnnotation> annotation = [view annotation];

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Disclosure Pressed" message:@"Click Cancel to Go Back" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alertView show];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // If it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // Handle any custom annotations.
    if ([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        // Try to dequeue an existing pin view first.
        MKAnnotationView *pinView = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        if (!pinView)
        {
            // If an existing pin view was not available, create one.
            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
            pinView.canShowCallout = YES;
            pinView.image = [UIImage imageNamed:@"pizza_slice_32.png"];
            pinView.calloutOffset = CGPointMake(0, 32);
            
            // Add a detail disclosure button to the callout.
            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            pinView.rightCalloutAccessoryView = rightButton;
            
            // Add an image to the left callout.
            UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pizza_slice_32.png"]];
            pinView.leftCalloutAccessoryView = iconView;
        } else {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    return nil;
}

@end
