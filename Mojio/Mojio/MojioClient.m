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
        [deviceDict setValue:@"80" forKey:@"Speed"];
        [deviceDict setValue:@"save" forKey:@"action"];
        
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:deviceDict options:NSJSONWritingPrettyPrinted error:&error];
        
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSMutableURLRequest *mutableRequest = [request mutableCopy];
        
        // hacks for now
        //self.apiToken=@"431b0301-d225-4d7b-a31e-2e00d198d3f2";
        
        [mutableRequest addValue:self.apiToken forHTTPHeaderField:@"MojioAPIToken"];
        
        [mutableRequest setHTTPMethod:@"PUT"];
        [mutableRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [mutableRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [mutableRequest setValue:[NSString stringWithFormat:@"%d", [jsonString length]] forHTTPHeaderField:@"Content-Length"];
        [mutableRequest setHTTPBody: jsonData];
        
        request = [mutableRequest copy];
        
        NSHTTPURLResponse *response = nil;
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
        
        //NSLog(@"%@",[[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding]);
        
    }
    else
    {
        NSLog(@"No user data recieved");
        //return nil;
    }
}

-(BOOL)isUserLoggedIn{
    //if you can get the user data with the current API, the user is logged in
    if ([[self getUserData] objectForKey:@"Data"]) {
        return true;
    }
    return false;
}

-(BOOL)storeMojio:(NSString*)deviceID andKey:(NSString*)key andValue:(NSString*)value{
    // store a key value pair for a device
    // use getStoredMojio with the deviceID key to grab the value
    
    if (self.apiToken) {
        NSString *str = [NSString stringWithFormat:@"http://sandbox.developer.moj.io/v1/mojios/%@/store/%@", deviceID,key];
        NSURL *url = [NSURL URLWithString:str];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSMutableURLRequest *mutableRequest = [request mutableCopy];
        NSMutableData *body = [NSMutableData data];
        
        // only strings are supported currently
        [body appendData:[[NSString stringWithFormat:@"\"%@\"",value] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [mutableRequest addValue:self.apiToken forHTTPHeaderField:@"MojioAPIToken"];
        
        [mutableRequest setHTTPMethod:@"PUT"];
        [mutableRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [mutableRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [mutableRequest setValue:[NSString stringWithFormat:@"%d", [value length]] forHTTPHeaderField:@"Content-Length"];
        [mutableRequest setHTTPBody: body];
        
        request = [mutableRequest copy];
        
        NSHTTPURLResponse *response = nil;
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
        
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        // if no response text is given, the put was successful
        if (returnString.length == 0) {
            return true;
        } else {
            return false;
        }
        
    }
    else
    {
        NSLog(@"No user data recieved");
        return false;
    }
}
-(NSString*)getStoredMojio:(NSString*)deviceID andKey:(NSString*)key{
    if (self.apiToken) {
        NSString *str = [NSString stringWithFormat:@"http://sandbox.developer.moj.io/v1/mojios/%@/store/%@",deviceID, key];
        NSURL *url = [NSURL URLWithString:str];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSMutableURLRequest *mutableRequest = [request mutableCopy];
        [mutableRequest addValue:self.apiToken forHTTPHeaderField:@"MojioAPIToken"];
        request = [mutableRequest copy];
        
        NSHTTPURLResponse *response = nil;
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
        id responseData=[NSJSONSerialization JSONObjectWithData:returnData options:
                         NSJSONReadingMutableContainers error:nil];
        
        // return the value string if successful
        if (responseData == nil) {
            NSString* value=[[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
            return value;
        } else {
            NSLog(@"Key: %@ is not defined", key);
            return nil;
        }
    }
    else
    {
        NSLog(@"No user data recieved");
        return nil;
    }
}
-(BOOL)deleteStoredMojio:(NSString*)deviceID andKey:(NSString*)key{
    if (self.apiToken) {
        NSString *str = [NSString stringWithFormat:@"http://sandbox.developer.moj.io/v1/mojios/%@/store/%@",deviceID, key];
        NSURL *url = [NSURL URLWithString:str];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSMutableURLRequest *mutableRequest = [request mutableCopy];
        [mutableRequest addValue:self.apiToken forHTTPHeaderField:@"MojioAPIToken"];
        [mutableRequest setHTTPMethod:@"DELETE"];
        request = [mutableRequest copy];
        
        NSHTTPURLResponse *response = nil;
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
        
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        // if no response text is given, the put was successful
        if (returnString.length == 0) {
            return true;
        } else {
            return false;
    
        }
    }
    else
    {
        NSLog(@"No user data recieved");
        return false;
    }
}

@end
