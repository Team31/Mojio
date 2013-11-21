//
//  SpeedSelectionViewController.m
//  Mojio
//
//  Created by Flynn Howling on 11/14/2013.
//  Copyright (c) 2013 team31. All rights reserved.
//

#import "SpeedSelectionViewController.h"

NSInteger speedS;

@interface SpeedSelectionViewController ()

@end

@implementation SpeedSelectionViewController

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
	// Do any additional setup after loading the view.
    self.speedSeletion  = [[NSArray alloc]         initWithObjects: @"0",@"50",@"60",@"70",@"80",@"90",@"100",@"110",@"120",@"130",nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    return 10;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
    return [self.speedSeletion objectAtIndex:row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component
{
    NSLog(@"Selected Row %ld", (long)row);
    if(_toggleUnite.selectedSegmentIndex == 0){
        switch(row)
        {
            
            case 0:
                self.speedSelected.text = @"0";
                speedS = 0;
                break;
            case 1:
                self.speedSelected.text = @"50";
                speedS = 50;
                break;
            case 2:
                self.speedSelected.text = @"60";
                speedS = 60;
                break;
            case 3:
                self.speedSelected.text = @"70";
                speedS = 70;
                break;
            case 4:
                self.speedSelected.text = @"80";
                speedS = 80;
                break;
            case 5:
                self.speedSelected.text = @"90";
                speedS = 90;
                break;
            case 6:
                self.speedSelected.text = @"100";
                speedS = 100;
                break;
            case 7:
                self.speedSelected.text = @"110";
                speedS = 110;
                break;
            case 8:
                self.speedSelected.text = @"120";
                speedS = 120;
                break;
            case 9:
                self.speedSelected.text = @"130";
                speedS = 130;
                break;
        }
    }
    else if (_toggleUnite.selectedSegmentIndex == 1){
        switch(row)
        {
                
            case 0:
                self.speedSelected.text = @"0";
                speedS = 0;
                break;
            case 1:
                self.speedSelected.text = @"30";
                speedS = 30;
                break;
            case 2:
                self.speedSelected.text = @"40";
                speedS = 40;
                break;
            case 3:
                self.speedSelected.text = @"50";
                speedS = 50;
                break;
            case 4:
                self.speedSelected.text = @"60";
                speedS = 60;
                break;
            case 5:
                self.speedSelected.text = @"70";
                speedS = 70;
                break;
            case 6:
                self.speedSelected.text = @"80";
                speedS = 80;
                break;
            case 7:
                self.speedSelected.text = @"90";
                speedS = 90;
                break;
            case 8:
                self.speedSelected.text = @"100";
                speedS = 100;
                break;
            case 9:
                self.speedSelected.text = @"110";
                speedS = 110;
                break;
        }
    }
}

- (IBAction)resetPressed:(id)sender{
    [_speedSelection selectRow:0 inComponent:0 animated:YES];
        self.speedSelected.text = @"Make Your Choice";
        _toggleUnite.selectedSegmentIndex = 0;
}
- (IBAction)setButtonPressed:(id)sender {
    //set the device's max speed to speedS
    ((Device*)[[[[Session sharedInstance] currentUser] devices] objectAtIndex:0]).speedLimit = speedS;

    
    [[self navigationController] popViewControllerAnimated:YES];
}

- (IBAction)toggleChanged:(id)sender {
    if(_toggleUnite.selectedSegmentIndex == 0){
        self.speedSelected.text = @"Make Your Choice";
        self.speedSeletion  = [[NSArray alloc]         initWithObjects: @"0",@"50",@"60",@"70",@"80",@"90",@"100",@"110",@"120",@"130",nil];
        [self.speedSelection reloadAllComponents];
    }
    else if (_toggleUnite.selectedSegmentIndex == 1){
        self.speedSelected.text = @"Make Your Choice";
        self.speedSeletion  = [[NSArray alloc]         initWithObjects: @"0",@"30",@"40",@"50",@"60",@"70",@"80",@"90",@"100",@"110",nil];
        [self.speedSelection reloadAllComponents];
    }
}
@end
