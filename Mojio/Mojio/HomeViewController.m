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
//MKMapView *mapView;

@interface HomeViewController ()
{
    Reachability *internetReachableFoo;
}
@property (strong, nonatomic) UIStoryboard *storyBoard;

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set the navigtion bar left and right buttons
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Devices" style:UIBarButtonItemStylePlain target:self action:@selector(manageDevicesTapped)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStylePlain target:self action:@selector(loginTapped)];
    
    //get main storyboard, we will instantiate viewControllers from this
    self.storyBoard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    [self testInternetConnection];
    //self.mapView.showsUserLocation = YES; //show current location
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.delegate = self;
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 250)];
    CLLocationCoordinate2D coord = {latitude: 49.25, longitude: -123.2};
    MKCoordinateSpan span = {latitudeDelta: 0.1, longitudeDelta: 0.1};
    MKCoordinateRegion region = {coord, span};
    [self.mapView setRegion:region];
    [self.view addSubview:self.mapView];
    MKPointAnnotation *myAnnotation = [[MKPointAnnotation alloc] init];
    myAnnotation.coordinate = CLLocationCoordinate2DMake(49.25, -123.2);
    //myAnnotation.title = @"Matthews Pizza";
    //myAnnotation.subtitle = @"Best Pizza in Town";
    [self.mapView addAnnotation:myAnnotation];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self attemptUserLogin];

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
    //Check if a user is currently logged in, pull data if they are
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)SpeedSelectionButtonPressed:(id)sender {
    UIViewController *speedSelectionViewController = (SpeedSelectionViewController *)[self.storyBoard instantiateViewControllerWithIdentifier:@"SpeedSelectionViewController"];
    [self.navigationController pushViewController:speedSelectionViewController animated:true];
}

- (void)loginTapped{
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
        [device setNickname:[deviceData objectForKey:@"Name"]];
        
        // set the device speed limit and on/off status
        [device setDeviceSpeedLimitData];
        
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


- (IBAction)getTripDataButtonPressed:(id)sender {
    /*
     get last trip ID
     get events for last trip
     calculate speed between each event
     if speed > threshold then alert user of speed and time, maybe location
     */
    //get the trips
    NSMutableArray* tripData = [[[[Session sharedInstance] client] getTripData] objectForKey:@"Data"];
    if ([tripData count] < 1) {
         self.tripDataTextView.text = @"No trip data";
        return;
    }
    //get the ID for the most recent trip
    NSString* tripIDString = [((NSMutableDictionary*)[tripData objectAtIndex:[tripData count]-1]) objectForKey:@"_id"];
    //get the events for that most recent trip
    NSMutableDictionary* tripEvents = [[[Session sharedInstance] client] getEventDataForTrip:tripIDString];
    NSMutableArray* tripEventsArray = [tripEvents objectForKey:@"Data"];
    //TODO: is this gaurunteed to be in order?
   
    //go through each event and calculate the speed between each event
    //based on the timestamp and location
    NSString *tripString = [NSString string];
    NSMutableDictionary* previousEvent = [[NSMutableDictionary alloc] init];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSTimeInterval differenceInTime;
    CLLocationDistance distance;
    double speed, exceededSpeed = 0;

    [dateFormat setDateFormat:@"yyyy-mm-dd'T'HH:mm:ss.SSS'Z'"];
    
    for (NSMutableDictionary *event in tripEventsArray) {
        
        if ([previousEvent objectForKey:@"Location"] && [event objectForKey:@"Location"]) {
            //convert string to time and get the difference between events
            NSDate *eventDate = [dateFormat dateFromString:[event objectForKey:@"Time"]];
            NSDate *previousEventDate = [dateFormat dateFromString:[previousEvent objectForKey:@"Time"]];
            differenceInTime = [eventDate timeIntervalSinceDate:previousEventDate];
            
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
            
            //calculate speed between events
            //write to the textfield
            if (distance < 1000) {
                tripString = [tripString stringByAppendingString:[NSString stringWithFormat:@"time: %f\n",differenceInTime]];
                tripString = [tripString stringByAppendingString:[NSString stringWithFormat:@"distance: %f\n",distance]];
                tripString = [tripString stringByAppendingString:[NSString stringWithFormat:@"speed: %f\n",(distance/differenceInTime)]];
                
                //just grab the last speeding speed for now to alert the user
                if (speed > 120) {
                    exceededSpeed = speed;
                }

            }
            else{
                 tripString = [tripString stringByAppendingString:@"A large value is here"];
            }
            
        }
        previousEvent = event;
    }
    
    if (tripEvents)
    {
        self.tripDataTextView.text = tripString;
    }
    else
    {
        self.tripDataTextView.text = @"No api key, please login";
    }
    //alert user of speeding
    if (exceededSpeed > 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Speeding Alert"
                                                        message:[NSString stringWithFormat:@"Vehicle reached %f km/h", exceededSpeed]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];

    }
}
- (IBAction)getUserDataButtonPressed:(id)sender {
    /*NSMutableArray* userData = [[[[Session sharedInstance] client] getUserData] objectForKey:@"Data"];
    NSMutableDictionary* userDict = [userData objectAtIndex:[userData count]-1];
    
    [userDict setValue:@"80" forKey:@"speed"];
    NSString* userID = [userDict objectForKey:@"_id"];
    
    [[[Session sharedInstance] client] saveUserData:userDict AndID:userID];
    
    NSMutableArray* deviceData = [[[[Session sharedInstance] client] getDevices] objectForKey:@"Data"];
    NSMutableDictionary* deviceDict = [deviceData objectAtIndex:[deviceData count]-1];
    
    NSString* deviceString = [NSString stringWithFormat:@"device: %@", deviceDict];
    self.userDataTextView.text = deviceString;*/
    
    //[self populateDeviceData];
    //[[[Session sharedInstance] client] saveDeviceData:@"testing" andName:@"testworkedwork"];
    //[[[Session sharedInstance] client] storeMojio:@"SimTest_4MTBJaqrb0lkXia5CtSV" andKey:@"speedLimit" andValue:@"70"];
    //[[[Session sharedInstance] client] getStoredMojio:@"testing" andKey:@"test1"];
    //[[[Session sharedInstance] client] deleteStoredMojio:@"testing" andKey:@"test2"];
    //[[[Session sharedInstance] client] getStoredMojio:@"testing" andKey:@"test2"];

}

- (void)testInternetConnection
{
    internetReachableFoo = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    // Internet is reachable
    internetReachableFoo.reachableBlock = ^(Reachability*reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Yayyy, we have the interwebs!");
        });
    };
    
    // Internet is not reachable
    internetReachableFoo.unreachableBlock = ^(Reachability*reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Someone broke the internet :(");
        });
    };
    
    [internetReachableFoo startNotifier];
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    id <MKAnnotation> annotation = [view annotation];
    if ([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        NSLog(@"Clicked Pizza Shop");
    }
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
