//
//  GPS.h
//  Proto3
//
//  Created by kkar on 6/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface GPS : NSObject <CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    NSString *latitude;
    NSString *longitude;
    BOOL locationSent;
}

+ (GPS *)sharedInstance;

- (void)start;
- (void)stop;
- (BOOL)locationKnown;

@property (nonatomic, retain) CLLocation *currentLocation;
@property (nonatomic, retain) NSString *latitude;
@property (nonatomic, retain) NSString *longitude;

@end
