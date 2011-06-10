//
//  MapViewController.h
//  Proto3
//
//  Created by Kimmo Kärkkäinen on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <math.h>
#import "NavigationViewController.h"
#import "GPS.h"
#import "MapViewAnnotation.h"

@interface MapViewController : UIViewController <MKMapViewDelegate> {
    NavigationViewController *navigationViewController;
    MKMapView *mapView;
    CLLocationCoordinate2D headlineLocation;
    NSString *headline;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) NSString *headline;

- (id)initWithLocation:(CLLocationCoordinate2D)location;

@end
