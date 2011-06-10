//
//  GPS.m
//  Proto3
//
//  Created by kkar on 6/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

// We use singleton for handling GPS so we can start finding location
// when the program starts and keep getting more accurate data all
// the time

#import "GPS.h"

@interface GPS (hidden)
- (void)setCoordinates;
@end

@implementation GPS

@synthesize currentLocation;
@synthesize latitude;
@synthesize longitude;

static GPS *sharedInstance;

+ (GPS *)sharedInstance
{
    @synchronized(self) {
        if (!sharedInstance) {
            sharedInstance = [[GPS alloc] init];
        }
    }
    return sharedInstance;
}

+ (id)alloc
{
    NSLog(@"GPS alloc happened");
    @synchronized(self) {
        NSAssert(sharedInstance == nil, @"Attempted to allocate a second instance of singleton GPS");
        sharedInstance = [super alloc];
    }
    return sharedInstance;
}

- (id)init
{
    @synchronized(self) {
        NSLog(@"GPS init happened");
        if ((self = [super init])) {
            self.currentLocation = [[[CLLocation alloc] init] autorelease];
            locationManager = [[CLLocationManager alloc] init];
            locationManager.delegate = self;
            [self start];
            locationSent = false;
        }
        return self;
    }
}

- (void)start
{
    [locationManager startUpdatingLocation];
    NSLog(@"Location manager started");
}

- (void)stop
{
    [locationManager stopUpdatingLocation];
    NSLog(@"Location manager stopped");
}

// We say that location is known only if it is known with 300m accuracy
// and is not older than 5 minutes.
- (BOOL)locationKnown
{
    if (currentLocation == nil || latitude == nil || longitude == nil || currentLocation.horizontalAccuracy > 300 || currentLocation.horizontalAccuracy < 0 || [currentLocation.timestamp timeIntervalSinceNow] < -300) {
        NSLog(@"Horizontal accuracy: %f", currentLocation.horizontalAccuracy);
        return NO;
    } else {
        NSLog(@"Horizontal accuracy: %f", currentLocation.horizontalAccuracy);
        return YES;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    // This will notify our AppDelegate to remove "gps disabled"-view,
    // if it is being shown currently.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"gpsWorks" object:nil];
    
    self.currentLocation = newLocation;
    [self setCoordinates];
    
    // Notifications make the main view update its data, so we avoid
    // sending it more than once, unless we have suddenly moved very much.
    if(([oldLocation distanceFromLocation:newLocation] > 500 || !locationSent) && [self locationKnown]) {
        NSLog(@"Got location");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"locationUpdate" object:nil];
        locationSent = true;
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSInteger errorCode = [error code];
    
    // If user has not allowed us to use GPS, our AppDelegate will handle
    // showing error view.
    if (errorCode == kCLErrorDenied) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"gpsDenied" object:nil];
    }
}

// This updates latitude and longitude variables from current coordinate 
// data, so we can more easily access those
- (void)setCoordinates
{
    CLLocationCoordinate2D currentCoordinates = currentLocation.coordinate;
    self.latitude = [[NSNumber numberWithDouble:currentCoordinates.latitude] stringValue];
    self.longitude = [[NSNumber numberWithDouble:currentCoordinates.longitude] stringValue];
}

@end
