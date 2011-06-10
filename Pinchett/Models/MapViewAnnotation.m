//
//  MapViewAnnotation.m
//  Proto3
//
//  Created by Kimmo Kärkkäinen on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MapViewAnnotation.h"


@implementation MapViewAnnotation

@synthesize latitude;
@synthesize longitude;
@synthesize title;

- (id)init
{
    return [super init];
}

- (void)dealloc
{
    [title release];
    [latitude release];
    [longitude release];
    [super dealloc];
}

- (CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]);
}

@end
