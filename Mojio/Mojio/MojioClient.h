//
//  MojioClient.h
//  mojioTesting
//
//  Created by Flynn Howling on 11/7/2013.
//  Copyright (c) 2013 team31. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MojioClient : NSObject

@property (strong, nonatomic) NSString *appID, *secretKey, *apiToken;
@property int pagesize;

-(NSString*)getAPIToken:(NSString*)username AndPassword:(NSString*)password;
-(NSMutableDictionary*)getTripData;
-(NSMutableDictionary*)getEventDataForTrip:(NSString*)tripID;
-(NSMutableDictionary*)getUserData;
-(NSMutableDictionary*)getDevices;
-(void)saveDeviceData:(NSString*)deviceID andName:(NSString*)deviceName;
-(BOOL)isUserLoggedIn;



@end
