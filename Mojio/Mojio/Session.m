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

@end
