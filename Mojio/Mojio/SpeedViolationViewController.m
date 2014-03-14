//
//  SpeedViolationViewController.m
//  Mojio
//
//  Created by Flynn Howling on 1/26/2014.
//  Copyright (c) 2014 team31. All rights reserved.
//

#import "SpeedViolationViewController.h"
#import "SpeedViolationDetailViewController.h"

@interface SpeedViolationViewController ()

@end

@implementation SpeedViolationViewController

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
    
    //get the data from NSUserDefaults
    self.navigationItem.title = @"Speed Violations";
    self.violationsArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"speedViolations"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.violationsArray.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"calendarCell";
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    // UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:24.0];
    
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:18.0];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.backgroundColor = [UIColor colorWithRed:22.0f/255.0f green:148.0f/255.0f blue:247.0f/255.0f alpha:1.0f];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    
    NSDateFormatter *dateFormatForDisplay = [[NSDateFormatter alloc] init];
    [dateFormatForDisplay setDateFormat:@"MMM dd, HH:mm"];
    
    NSDate *date = [dateFormat dateFromString:[((NSDictionary*)[self.violationsArray objectAtIndex:(self.violationsArray.count - 1) - indexPath.row]) objectForKey:@"Date"]];
    
    
    
    cell.textLabel.text = [dateFormatForDisplay stringFromDate:date];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ km/h", [((NSDictionary*)[self.violationsArray objectAtIndex:(self.violationsArray.count - 1) - indexPath.row]) objectForKey:@"Speed"]];
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    SpeedViolationDetailViewController *speedViolationDetail = (SpeedViolationDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"SpeedViolationDetailViewController"];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    NSDateFormatter *dateFormatForDisplay = [[NSDateFormatter alloc] init];
    [dateFormatForDisplay setDateFormat:@"MMM dd, HH:mm"];
    NSDate *date = [dateFormat dateFromString:[((NSDictionary*)[self.violationsArray objectAtIndex:(self.violationsArray.count - 1) - indexPath.row]) objectForKey:@"Date"]];
    
    speedViolationDetail.date = [dateFormatForDisplay stringFromDate:date];
    speedViolationDetail.speed = [NSString stringWithFormat:@"%@ km/h", [((NSDictionary*)[self.violationsArray objectAtIndex:(self.violationsArray.count - 1) - indexPath.row]) objectForKey:@"Speed"]];
    speedViolationDetail.latitude = [((NSDictionary*)[self.violationsArray objectAtIndex:(self.violationsArray.count - 1) - indexPath.row]) objectForKey:@"Latitude"];
    speedViolationDetail.longitude = [((NSDictionary*)[self.violationsArray objectAtIndex:(self.violationsArray.count - 1) - indexPath.row]) objectForKey:@"Longitude"];
    
    [self.navigationController pushViewController:speedViolationDetail animated:true];

}



/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
 */


@end
