//
//  Session.m
//  Mojio
//
//  Created by Flynn Howling on 11/14/2013.
//  Copyright (c) 2013 team31. All rights reserved.
//

#import "Session.h"

@implementation Session

+ (Session*)sharedInstance
{
    static Session *_sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[Session alloc] init];
    });
    return _sharedInstance;
}

-(MojioClient *) client
{
    if (!_client) _client = [[MojioClient alloc] init];
    return _client;
}

-(BOOL)login:(NSString*)username AndPassword:(NSString*)password
{
    // set the session API token if login information is correct
    NSString *response = [self.client getAPIToken:username AndPassword:password];
    
    if(response.length > 0){
        self.APIToken = response;
        self.client.apiToken = response;
        //TODO: I think its redundant for us to set two apiTokens
        //TODO: apitoken should persist, it gets reset on every app launch now
        return true;
    }
    return false;
}
@end
