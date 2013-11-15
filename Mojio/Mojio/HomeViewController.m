//
//  HomeViewController.m
//  Mojio
//
//  Created by Flynn Howling on 11/14/2013.
//  Copyright (c) 2013 team31. All rights reserved.
//

#import "HomeViewController.h"
#import "SpeedSelectionViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)SpeedSelectionButtonPressed:(id)sender {
    UIStoryboard *speedSelection = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    UIViewController *speedSelectionViewController = (SpeedSelectionViewController *)[speedSelection instantiateViewControllerWithIdentifier:@"SpeedSelectionViewController"];
    [self presentViewController:speedSelectionViewController animated:true completion:^(void){}];
}

@end
