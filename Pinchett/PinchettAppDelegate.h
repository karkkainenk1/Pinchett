//
//  PinchettAppDelegate.h
//  Pinchett
//
//  Created by kkar on 6/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoCache.h"

@interface PinchettAppDelegate : NSObject <UIApplicationDelegate> {
    UIViewController *gpsDeniedViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

- (void)gpsDenied;
- (void)gpsAllowed;

@end
