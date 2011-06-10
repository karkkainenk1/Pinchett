//
//  NavigationViewController.m
//  Proto3
//
//  Created by Kimmo Kärkkäinen on 6/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


// We use our own, custom navigation controller. You must be asking
// why would we do this. The reason is that iOS 4.3 SDK has a funny bug.
// For some weird reason you cannot sometimes remove the default back 
// button, unless you hide/redisplay the navigation bar. Because we use
// a custom back button and hiding/redisplaying the bar just can't be 
// done without annoying the user, this is the only way to achieve the 
// desired result.


#import "NavigationViewController.h"

@implementation NavigationViewController

@synthesize controller;

- (void)dealloc
{
    [controller release];
    [super dealloc];
}

- (IBAction)backButtonPressed:(id)sender {
    [controller.navigationController popViewControllerAnimated:YES];
}

@end
