//
//  SpeedViolation.h
//  Mojio
//
//  Created by Flynn Howling on 1/26/2014.
//  Copyright (c) 2014 team31. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface SpeedViolation : NSObject <NSCoding>

@property float speed;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) CLLocation *location;

@end
