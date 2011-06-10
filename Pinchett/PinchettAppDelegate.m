//
//  PinchettAppDelegate.m
//  Pinchett
//
//  Created by kkar on 6/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PinchettAppDelegate.h"
#import "LoginViewController.h"
#import "GPS.h"

@implementation PinchettAppDelegate


@synthesize window=_window;

@synthesize navigationController=_navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gpsDenied) name:@"gpsDenied" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gpsAllowed) name:@"gpsWorks" object:nil];
    
    // Get GPS sharedInstance, so that it initializes and starts
    // updating location data.
    [GPS sharedInstance];
   
    // Override point for customization after application launch.
    // Add the navigation controller's view to the window and display.
    self.window.rootViewController = self.navigationController;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    [[GPS sharedInstance] stop];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"Application will enter foreground");
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
    //[self gpsAllowed];
    
    GPS *gps = [GPS sharedInstance];
    [gps start];
    
    /*if (![gps locationDisabled]) {
        [self gpsAllowed];
    }*/
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"Application did become active");
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    [[self.navigationController topViewController] viewWillAppear:YES];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    [_navigationController release];
    [super dealloc];
}

- (void)gpsDenied
{
    @synchronized(self) {
        if (gpsDeniedViewController == nil) {
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"GpsDisabled" owner:self options:nil];
            if ([nibs count] > 0) {
                UIView *gpsDeniedView = [nibs objectAtIndex:0];
                gpsDeniedViewController = [[UIViewController alloc] init];
                gpsDeniedViewController.view = gpsDeniedView;
                [self.navigationController pushViewController:gpsDeniedViewController animated:YES];
            }
        }
    }
}

- (void)gpsAllowed
{
    @synchronized(self) {
        if ([self.navigationController topViewController] == gpsDeniedViewController) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        [gpsDeniedViewController release];
        gpsDeniedViewController = nil;
    }
}

@end
