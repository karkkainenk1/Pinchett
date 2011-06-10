//
//  NavigationViewController.h
//  Proto3
//
//  Created by Kimmo Kärkkäinen on 6/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kBackButton 100

@interface NavigationViewController : UIViewController {
    UIViewController *controller;
}

@property (nonatomic, retain) UIViewController *controller;

- (IBAction)backButtonPressed:(id)sender;

@end
