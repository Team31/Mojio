//
//  HomeViewController.m
//  Mojio
//
//  Created by Flynn Howling on 11/14/2013.
//  Copyright (c) 2013 team31. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()
@property (strong, nonatomic) UIStoryboard *storyBoard;

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Check if a user is currently logged in, pull data if they are
    [self attemptUserLogin];
    
    
    //set the navigtion bar left and right buttons
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Devices" style:UIBarButtonItemStylePlain target:self action:@selector(manageDevicesTapped)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStylePlain target:self action:@selector(loginTapped)];
    
    //get main storyboard, we will instantiate viewControllers from this
    self.storyBoard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    //make home page title the first device nickname, if it exists
    if (((Device*)[[[[Session sharedInstance] currentUser] devices] objectAtIndex:0]).nickname)
    {
        self.navigationItem.title = ((Device*)[[[[Session sharedInstance] currentUser] devices] objectAtIndex:0]).nickname;
    }
    else
    {
        self.navigationItem.title = @"Home";
    }

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
    NSMutableArray* deviceData = [[[[Session sharedInstance] client] getDevices] objectForKey:@"Data"];
    
    for (NSMutableDictionary *event in deviceData) {
        // define each device: idNumber, speedLimit and nickname
        Device *device = [[Device alloc] init];
        device.speedLimit = 10;
        device.idNumber = [event objectForKey:@"_id"];
        device.nickname = [event objectForKey:@"Name"];
        
        // and add it to deviceList
        [deviceList addObject:device];
    }
    User *userOne = [[User alloc] init];
    [userOne setUsername:@"TestUserName"];
    [userOne setDevices:deviceList];
    //start session singlton
    [[Session sharedInstance] setCurrentUser:userOne];
    
    //refresh the homepage title for the new device downloaded
    [self viewDidAppear:true];
    
}

- (void)makeTestData{
    //make some test devices
    Device *deviceOne = [[Device alloc] init];
    deviceOne.speedLimit = 60;
    deviceOne.idNumber = @"12345";
    deviceOne.nickname = @"Red Car";
    Device *deviceTwo = [[Device alloc] init];
    deviceTwo.speedLimit = 70;
    deviceTwo.idNumber = @"12345";
    deviceTwo.nickname = @"Blue Car";
    Device *deviceThree = [[Device alloc] init];
    deviceThree.speedLimit = 80;
    deviceThree.idNumber = @"12345";
    deviceThree.nickname = @"Green Car";
    
    //make test user
    User *userOne = [[User alloc] init];
    [userOne setUsername:@"TestUserName"];
    [userOne setDevices:[[NSArray alloc] initWithObjects:deviceOne, deviceTwo, deviceThree, nil]];
    //start session singlton
    [[Session sharedInstance] setCurrentUser:userOne];

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


- (IBAction)getTripDataButtponPressed:(id)sender {
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
    
    [self populateDeviceData];
    //[[[Session sharedInstance] client] saveDeviceData:@"testing" andName:@"testworkedwork"];
    //[[[Session sharedInstance] client] storeMojio:@"testing" andKey:@"test2" andValue:@"work2"];
    //[[[Session sharedInstance] client] getStoredMojio:@"testing" andKey:@"test1"];
    //[[[Session sharedInstance] client] deleteStoredMojio:@"testing" andKey:@"test2"];
    //[[[Session sharedInstance] client] getStoredMojio:@"testing" andKey:@"test2"];

}
@end
