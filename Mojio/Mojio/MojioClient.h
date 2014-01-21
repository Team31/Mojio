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

// methods to store, get and delete values for a Mojio device
-(BOOL)storeMojio:(NSString*)deviceID andKey:(NSString*)key andValue:(NSString*)value;
-(NSString*)getStoredMojio:(NSString*)deviceID andKey:(NSString*)key;
-(BOOL)deleteStoredMojio:(NSString*)deviceID andKey:(NSString*)key;


@end
