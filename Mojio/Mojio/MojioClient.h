//
//  MojioClient.h
//  mojioTesting
//
//  Created by Flynn Howling on 11/7/2013.
//  Copyright (c) 2013 team31. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MojioClient : NSObject

//@property (strong, nonatomic) NSString *appID, *secretKey, *apiToken;
@property int pagesize;

-(NSString*)getAPIToken:(NSString*)username AndPassword:(NSString*)password;
-(NSMutableDictionary*)getTripData;
-(NSMutableDictionary*)getEventDataForTrip:(NSString*)tripID;
-(NSMutableDictionary*)getUserData;
-(NSMutableDictionary*)getDevices;
-(void)saveDeviceData:(NSString*)deviceID andName:(NSString*)deviceName;
-(BOOL)isUserLoggedIn;

// methods to store, get and delete values for a Mojio device
-(NSString*)DictionaryToString:(NSDictionary*)inputDict;

-(BOOL)storeMojio:(NSString*)deviceID andKey:(NSString*)key andValue:(NSString*)value;
-(NSString*)getStoredMojio:(NSString*)deviceID andKey:(NSString*)key;
-(BOOL)deleteStoredMojio:(NSString*)deviceID andKey:(NSString*)key;




// CLEANING IN PROCESS
@property (nonatomic) NSString *Mojio, *appID, *secretKey, *apiToken, *minutes;
-(void) initialize;
-(NSString*) getURL:(NSString*)controller andID:(NSString*)id andAction:(NSString*)action andKey:(NSString*)key;


-(NSData*)sendRequest:(NSString*)url andData:(NSString*) data andMethod:(NSString*) method;

-(NSString*)dataByMethodData:(NSData*)data andMethod:(NSString*) method;
-(NSString*)dataByMethodDict:(NSDictionary*)dict andMethod:(NSString*) method;

-(void)get;
-(void)post;
-(void)delete;
-(void)put;

@end
