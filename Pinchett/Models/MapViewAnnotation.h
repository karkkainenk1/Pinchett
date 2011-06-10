//
//  MapViewAnnotation.h
//  Proto3
//
//  Created by Kimmo Kärkkäinen on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface MapViewAnnotation : NSObject <MKAnnotation> {
    NSNumber *latitude;
    NSNumber *longitude;
    NSString *title;
}

@property (nonatomic, retain) NSNumber *latitude;
@property (nonatomic, retain) NSNumber *longitude;
@property (nonatomic, retain) NSString *title;

@end
