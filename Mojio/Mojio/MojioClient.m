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

-(NSMutableDictionary*)getTripData
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
        
      //  NSArray *trips = [responseData objectForKey:@"Data"];
      //  NSString *tripString = [NSString stringWithFormat:@"%@", responseData];
        return responseData;
        
    }
    else
    {
        NSLog(@"No trip data recieved");
        return nil;
    }
    
}

-(NSMutableDictionary*)getEventDataForTrip:(NSString*)tripID
{
    if (self.apiToken) {
        //TODO pagesize should be variable
        //Insert tripID
        NSString *str = [NSString stringWithFormat:@"http://sandbox.developer.moj.io/v1/trips/%@/events?pageSize=10",tripID];
        NSURL *url = [NSURL URLWithString:str];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSMutableURLRequest *mutableRequest = [request mutableCopy];
        [mutableRequest addValue:self.apiToken forHTTPHeaderField:@"MojioAPIToken"];
        request = [mutableRequest copy];
        
        NSHTTPURLResponse *response = nil;
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
        
        id responseData=[NSJSONSerialization JSONObjectWithData:returnData options:
                         NSJSONReadingMutableContainers error:nil];
        
        return responseData;
        
    }
    else
    {
        NSLog(@"No trip data recieved");
        return nil;
    }
    
}


-(NSMutableDictionary*)getUserData
{
    if (self.apiToken) {
        //TODO pagesize should be variable
        NSString *str = @"http://sandbox.developer.moj.io/v1/users/";
        NSURL *url = [NSURL URLWithString:str];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSMutableURLRequest *mutableRequest = [request mutableCopy];
        [mutableRequest addValue:self.apiToken forHTTPHeaderField:@"MojioAPIToken"];
        request = [mutableRequest copy];
        
        NSHTTPURLResponse *response = nil;
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
        
        id responseData=[NSJSONSerialization JSONObjectWithData:returnData options:
                         NSJSONReadingMutableContainers error:nil];
        
        //  NSArray *trips = [responseData objectForKey:@"Data"];
        //  NSString *tripString = [NSString stringWithFormat:@"%@", responseData];
        return responseData;
        
    }
    else
    {
        NSLog(@"No user data recieved");
        return nil;
    }
    
}

-(NSMutableDictionary*)getDevices
{
    if (self.apiToken) {
        //TODO pagesize should be variable
        NSString *str = @"http://sandbox.developer.moj.io/v1/mojios/";
        NSURL *url = [NSURL URLWithString:str];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSMutableURLRequest *mutableRequest = [request mutableCopy];
        [mutableRequest addValue:self.apiToken forHTTPHeaderField:@"MojioAPIToken"];
        request = [mutableRequest copy];
        
        NSHTTPURLResponse *response = nil;
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
        
        id responseData=[NSJSONSerialization JSONObjectWithData:returnData options:
                         NSJSONReadingMutableContainers error:nil];
        
        //  NSArray *trips = [responseData objectForKey:@"Data"];
        //  NSString *tripString = [NSString stringWithFormat:@"%@", responseData];
        return responseData;
        
    }
    else
    {
        NSLog(@"No user data recieved");
        return nil;
    }
    
}

-(void)saveDeviceData:(NSString*)deviceID andName:(NSString*)deviceName
{
    NSError* error;
    if (self.apiToken) {
        NSString *str = [NSString stringWithFormat:@"http://sandbox.developer.moj.io/v1/mojios/%@", deviceID];
        NSURL *url = [NSURL URLWithString:str];
        NSString *jsonString;
        
        NSMutableDictionary *deviceDict = [[NSMutableDictionary alloc] init];
        [deviceDict setValue:deviceID forKey:@"Id"];
        [deviceDict setValue:deviceID forKey:@"_id"];
        [deviceDict setValue:deviceName forKey:@"Name"];
        [deviceDict setValue:@"save" forKey:@"action"];
        
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:deviceDict options:NSJSONWritingPrettyPrinted error:&error];
        
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSMutableURLRequest *mutableRequest = [request mutableCopy];
        
        // hacks for now
        //self.apiToken=@"444eb588-ce29-4d4d-a20d-a7d62d88ce38";
        
        [mutableRequest addValue:self.apiToken forHTTPHeaderField:@"MojioAPIToken"];
        
        [mutableRequest setHTTPMethod:@"PUT"];
        [mutableRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [mutableRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [mutableRequest setValue:[NSString stringWithFormat:@"%d", [jsonString length]] forHTTPHeaderField:@"Content-Length"];
        [mutableRequest setHTTPBody: jsonData];
        
        request = [mutableRequest copy];
        
        NSHTTPURLResponse *response = nil;
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
        
        NSString* testString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        NSLog(testString);
        /*id responseData=[NSJSONSerialization JSONObjectWithData:returnData options:
                         NSJSONReadingMutableContainers error:nil];*/
        
        //  NSArray *trips = [responseData objectForKey:@"Data"];
        //  NSString *tripString = [NSString stringWithFormat:@"%@", responseData];
        //return responseData;
        
    }
    else
    {
        NSLog(@"No user data recieved");
        //return nil;
    }
    
}

@end
