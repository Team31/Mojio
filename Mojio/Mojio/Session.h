//
//  Session.h
//  Mojio
//
//  Created by Flynn Howling on 11/14/2013.
//  Copyright (c) 2013 team31. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "MojioClient.h"

@interface Session : NSObject

@property (strong, nonatomic) User *currentUser;
@property (strong, nonatomic) MojioClient *client;
@property (strong, nonatomic) NSString *APIToken;

+ (Session *)sharedInstance;
-(BOOL)login:(NSString*)username AndPassword:(NSString*)password;
-(void)logoutCurrentUser;

@end
