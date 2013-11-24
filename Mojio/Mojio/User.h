//
//  User.h
//  Mojio
//
//  Created by Flynn Howling on 11/14/2013.
//  Copyright (c) 2013 team31. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Device.h"

@interface User : NSObject

//TODO: not sure if we should be saving user passwords
@property (strong, nonatomic) NSString *username, *password;
@property (strong, nonatomic) NSArray *devices;

//TODO: not sure if current device should be stored in User or homeviewcontroller
@property (strong, nonatomic) Device *currentDevice;

@end
