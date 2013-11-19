//
//  MojioClient.m
//  mojioTesting
//
//  Created by Flynn Howling on 11/7/2013.
//  Copyright (c) 2013 team31. All rights reserved.
//

#import "MojioClient.h"

@interface MojioClient()
//The interface within an implementation file is used to store private data
@property NSMutableData *responseData;
@property NSURLConnection *tripConnection;

@end

@implementation MojioClient

-(NSString*)getAPIToken:(NSString*)username AndPassword:(NSString*)password
{
    NSString *str = [NSString stringWithFormat:@"http://sandbox.developer.moj.io/v1/login/%%7Bid%%7D/begin?id=87708830-31B7-464F-85D3-9E8FD22A2A10&secretKey=c861e8a6-e230-4bd4-9c7c-241144071254&userOrEmail=%@&password=%@&minutes=120",username, password];
    NSURL *url = [NSURL URLWithString:str];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSError *error=nil;
    id response=[NSJSONSerialization JSONObjectWithData:data options:
                 NSJSONReadingMutableContainers error:&error];
    if ([response objectForKey:@"_id"]) {
        return [response objectForKey:@"_id"];
    }

    return @"";
}

-(NSString*)getTripData
{
    if (self.apiToken) {
        //TODO pagesize should be variable
        NSString *str = @"http://sandbox.developer.moj.io/v1/trips/?pageSize=10";
        NSURL *url = [NSURL URLWithString:str];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSMutableURLRequest *mutableRequest = [request mutableCopy];
        [mutableRequest addValue:self.apiToken forHTTPHeaderField:@"MojioAPIToken"];
        request = [mutableRequest copy];
        
        NSHTTPURLResponse *response = nil;
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];

        id responseData=[NSJSONSerialization JSONObjectWithData:returnData options:
                     NSJSONReadingMutableContainers error:nil];
        
        NSArray *trips = [responseData objectForKey:@"Data"];
        NSString *tripString = [NSString stringWithFormat:@"%@", trips];
        return tripString;
        
    }
    else
    {
        NSLog(@"No trip data recieved");
        return nil;
    }
    
}



@end
