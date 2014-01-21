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
@property(nonatomic,strong) Session *session;
@end

@implementation MojioClientTest
@synthesize mc;

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    self.mc = [[MojioClient alloc]init];
    self.session = [[Session sharedInstance]init];
}

- (void)testgetAPITokenValidCred
{
    NSString *username=@"team31";
    NSString *password=@"Teamthirty1";
    
    NSString *response = [self.mc getAPIToken:username AndPassword:password];
    
    XCTAssertTrue(![response isEqual:@""], @"Get API Token Test with Valid Cred.");
}

- (void)testgetAPITokenInvalidCred
{
    NSString *username=@"testgetAPITokenInvalid";
    NSString *password=@"testgetAPITokenInvalid";
    NSString *response = [self.mc getAPIToken:username AndPassword:password];
    
    XCTAssertTrue([response isEqual:@""], @"Get API Token Test with Invalid Cred.");
}

- (void)testgetTripDataWithSession
{
    NSString *username=@"team31";
    NSString *password=@"Teamthirty1";
    [self.session login:username AndPassword:password];
    NSMutableDictionary *response = [[NSMutableDictionary alloc] init];
    response = [[[self.session client] getTripData] objectForKey:@"Data"];
    XCTAssertNotNil(response, @"Get Trip Data Test with Session");
    
}

- (void)testgetTripDataWithOutSession
{
    self.session = nil;
    NSMutableDictionary *response = [[NSMutableDictionary alloc] init];
    response = [[[self.session client] getTripData] objectForKey:@"Data"];
    XCTAssertNil(response, @"Get Trip Data Test without Session");
    
}

- (void)testgetTripDataWithInvalidKey
{
    NSString *username=@"team31";
    NSString *password=@"Teamthirty1";
    [self.session login:username AndPassword:password];
    NSMutableDictionary *response = [[NSMutableDictionary alloc] init];
    response = [[[self.session client] getTripData] objectForKey:@"BAD_KEY"];
    XCTAssertNil(response, @"Get Trip Data Test with Invalid Key");
    
}

- (void)testgetEventDataForTripWithValidTripID
{
    NSString *username=@"team31";
    NSString *password=@"Teamthirty1";
    [self.session login:username AndPassword:password];
    NSMutableArray* tripData = [[[self.session client] getTripData] objectForKey:@"Data"];
    //get the ID for the most recent trip
    NSString* tripIDString = [((NSMutableDictionary*)[tripData objectAtIndex:[tripData count]-1]) objectForKey:@"_id"];
    //get the events for that most recent trip
    NSMutableDictionary* tripEvents = [[self.session client] getEventDataForTrip:tripIDString];
    
    XCTAssertNotNil(tripEvents, @"Get Event Data for Trip with Valid TripID");
}

- (void)testgetEventDataForTripWithInvalidSession
{
    self.session = nil;
    //[self.session login:username AndPassword:password];
    NSMutableArray* tripData = [[[self.session client] getTripData] objectForKey:@"Data"];
    //get the ID for the most recent trip
    NSString* tripIDString = [((NSMutableDictionary*)[tripData objectAtIndex:[tripData count]-1]) objectForKey:@"_id"];
    //get the events for that most recent trip
    NSMutableDictionary* tripEvents = [[self.session client] getEventDataForTrip:tripIDString];
    
    XCTAssertNil(tripEvents, @"Get Event Data for Trip with Invalid Session");
}

- (void)testgetEventDataForTripWithInvalidTripID
{
    NSString *username=@"team31";
    NSString *password=@"Teamthirty1";
    [self.session login:username AndPassword:password];
    //get the ID for the most recent trip
    NSString* tripIDString = @"";
    //get the events for that most recent trip
    NSMutableDictionary* tripEvents = [[self.session client] getEventDataForTrip:tripIDString];
    NSString *expectation = [tripEvents objectForKey:@"Message"];
    XCTAssertTrue([expectation isEqualToString:@"The request is invalid."], @"Get Event Data for Trip with Invalid TripID");
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    self.mc = nil;
    self.session = nil;
    [super tearDown];

}
@end
