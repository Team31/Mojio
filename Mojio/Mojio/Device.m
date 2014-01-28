//
//  Device.m
//  Mojio
//
//  Created by Flynn Howling on 11/14/2013.
//  Copyright (c) 2013 team31. All rights reserved.
//

#import "Device.h"
#import "Session.h"

@implementation Device

- (void)setDeviceSpeedLimitData{
    // if the device id is set, gets the device speed limit and on off status from Mojio server and sets them
    if (self.idNumber != nil) {
        // get speed limit from Mojio server if defined, otherwise set speed limit to zero and onOff to off
        NSString* deviceData = [[NSString alloc]init];
        NSString* speedLimitReturned = [[NSString alloc]init];
        NSString* onOffReturned = [[NSString alloc]init];
        
        deviceData = [[[Session sharedInstance] client] getStoredMojio:self.idNumber andKey:@"deviceData"];
        
        // unescape any escaped characters
        NSString *unescaped = [[deviceData stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""]stringByReplacingOccurrencesOfString:@"\\\\n" withString:@"\n"];
        
        // attempt to read device data from returned JSON string
        
        // remove the extra double quotes around the string
        NSString *newString = [unescaped substringWithRange:NSMakeRange(1, [unescaped length]-2)];
        NSData *jsonData = [newString dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:jsonData options:0  error:nil];
        
        if (json != nil) {
            speedLimitReturned = [NSString stringWithFormat:@"\"%@\"",[json objectForKey:@"speed"]];
            // remove double quotes from the start and end of the string so the integer conversion works properly
            speedLimitReturned = [speedLimitReturned substringFromIndex:1];
            speedLimitReturned = [speedLimitReturned substringToIndex:[speedLimitReturned length] - 1];
            self.speedLimit = [speedLimitReturned intValue];
            
            // get on off status of the device if speed limit is set
            onOffReturned = [NSString stringWithFormat:@"\"%@\"",[json objectForKey:@"onOrOff"]];
            if ([onOffReturned isEqualToString:@"\"ON\""]){
                self.onOff = true;
            } else {
                self.onOff = false;
            }
        } else {
            // default to speed limit of zero and false
            self.speedLimit = 0;
            self.onOff = false;
        }
        
    } else {
        NSLog(@"device id not set");
    }
    
}

- (NSMutableDictionary*)createMojioDictionary{
    NSMutableDictionary *mojioData = [[NSMutableDictionary alloc] init];
    [mojioData setObject:[NSString stringWithFormat:@"%d",self.speedLimit] forKey:@"speed"];
    [mojioData setObject:[NSString stringWithFormat:@"%@", self.onOff ? @"ON" : @"OFF"] forKey:@"onOrOff"];
    [mojioData setObject:self.nickname forKey:@"nickName"];
    
    return mojioData;
}

@end
