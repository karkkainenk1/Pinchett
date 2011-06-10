//
//  MapViewController.m
//  Proto3
//
//  Created by Kimmo Kärkkäinen on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"


@implementation MapViewController

@synthesize mapView;
@synthesize headline;

- (id)initWithLocation:(CLLocationCoordinate2D)location
{
    headlineLocation = location;
    return [super init];
}

- (void)dealloc
{
    [navigationViewController release];
    [mapView release];
    [headline release];
    [super dealloc];
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    navigationViewController = [[NavigationViewController alloc] init];
    navigationViewController.controller = self;
    [self.view addSubview:navigationViewController.view];
    
    CLLocationCoordinate2D currentLocation = [GPS sharedInstance].currentLocation.coordinate;
    
    CLLocationDegrees latitudeDifference = fabs(currentLocation.latitude-headlineLocation.latitude);
    CLLocationDegrees longitudeDifference = fabs(currentLocation.longitude-headlineLocation.longitude);
    
    if(latitudeDifference < 0.002) latitudeDifference = 0.002;
    if(longitudeDifference < 0.002) longitudeDifference = 0.002;
    
    [mapView setShowsUserLocation:YES];
    [mapView setCenterCoordinate:headlineLocation];
    
    MapViewAnnotation *annotation = [[MapViewAnnotation alloc] init];
    annotation.latitude = [NSNumber numberWithDouble:headlineLocation.latitude];
    annotation.longitude = [NSNumber numberWithDouble:headlineLocation.longitude];
    annotation.title = headline;    
    
    [mapView addAnnotation:annotation];
    
    [annotation release];
    
    [mapView setRegion:MKCoordinateRegionMake(headlineLocation, MKCoordinateSpanMake(latitudeDifference*3.3, longitudeDifference*2.2))];
    
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

@end
