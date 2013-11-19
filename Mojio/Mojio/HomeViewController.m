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
    //TODO: Check if a user is currently logged in
    //This is just for testing with some data until we can pull it from the mojio server
    
    //Make test data (only for testing, remove later)
    [self makeTestData];
    
    
    //make home page title the first device nickname, if it exists
    if (((Device*)[[[[Session sharedInstance] currentUser] devices] objectAtIndex:0]).nickname)
    {
        self.navigationItem.title = ((Device*)[[[[Session sharedInstance] currentUser] devices] objectAtIndex:0]).nickname;
    }
    else
    {
        self.navigationItem.title = @"Home";
    }

    //set the navigtion bar left and right buttons
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Devices" style:UIBarButtonItemStylePlain target:self action:@selector(manageDevicesTapped)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStylePlain target:self action:@selector(loginTapped)];
    
    //get main storyboard, we will instantiate viewControllers from this
    self.storyBoard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
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
@end
