//
//  MojioClientTest.m
//  Mojio
//
//  Created by bananas on 2013-11-21.
//  Copyright (c) 2013 team31. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MojioClient.h"
#import "Session.h"

@interface MojioClientTest : XCTestCase
@property(nonatomic,strong) MojioClient *mc;
@end

@implementation MojioClientTest
@synthesize mc;

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    self.mc = [[MojioClient alloc]init];
}

- (void)testgetAPITokenValid
{
    NSString *username=@"team31";
    NSString *password=@"Teamthirty1";
    
    NSString *response = [self.mc getAPIToken:username AndPassword:password];
    
    XCTAssertTrue(![response isEqual:@""], @"Get API Token Test with Valid Cred.");
}

- (void)testgetAPITokenInvalid
{
    NSString *username=@"test";
    NSString *password=@"test";
    NSString *response = [self.mc getAPIToken:username AndPassword:password];
    
    XCTAssertTrue([response isEqual:@""], @"Get API Token Test with Invalid Cred.");
}

- (void)testgetTripDataWithSession
{
    NSString *username=@"team31";
    NSString *password=@"Teamthirty1";
    [[Session sharedInstance] login:username AndPassword:password];
    NSMutableDictionary *response = [[NSMutableDictionary alloc] init];
    response = [[[[Session sharedInstance] client] getTripData] objectForKey:@"Data"];
    XCTAssertNotNil(response, @"Get Trip Data Test with Session");
    
}

- (void)testgetTripDataWithOutSession
{
    NSMutableDictionary *response = [[NSMutableDictionary alloc] init];
    response = [[[[Session sharedInstance] client] getTripData] objectForKey:@"Data"];
    XCTAssertNil(response, @"Get Trip Data Test without Session");
    
}

- (void)testgetEventDataForTripWithValidTripID
{
    NSString *username=@"team31";
    NSString *password=@"Teamthirty1";
    [[Session sharedInstance] login:username AndPassword:password];
    NSMutableArray* tripData = [[[[Session sharedInstance] client] getTripData] objectForKey:@"Data"];
    //get the ID for the most recent trip
    NSString* tripIDString = [((NSMutableDictionary*)[tripData objectAtIndex:[tripData count]-1]) objectForKey:@"_id"];
    //get the events for that most recent trip
    NSMutableDictionary* tripEvents = [[[Session sharedInstance] client] getEventDataForTrip:tripIDString];
    
    XCTAssertNotNil(tripEvents, @"Get Event Data for Trip with Valid TripID");
}

- (void)testgetEventDataForTripWithInvalidTripID
{
    NSString *username=@"test";
    NSString *password=@"test";
    [[Session sharedInstance] login:username AndPassword:password];
    NSMutableArray* tripData = [[[[Session sharedInstance] client] getTripData] objectForKey:@"Data"];
    //get the ID for the most recent trip
    NSString* tripIDString = [((NSMutableDictionary*)[tripData objectAtIndex:[tripData count]-1]) objectForKey:@"_id"];
    //get the events for that most recent trip
    NSMutableDictionary* tripEvents = [[[Session sharedInstance] client] getEventDataForTrip:tripIDString];
    
    XCTAssertNil(tripEvents, @"Get Event Data for Trip with Valid TripID");
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}
@end
