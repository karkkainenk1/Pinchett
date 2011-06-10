//
//  PhotoViewController.h
//  Proto3
//
//  Created by kkar on 6/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "NavigationViewController.h"
#import "PhotoModel.h"

@interface PhotoViewController : UIViewController <ASIHTTPRequestDelegate, UIScrollViewDelegate, MBProgressHUDDelegate, PhotoDelegate> {
    MBProgressHUD *HUD;
    UIScrollView *scrollView;
    UIView *imageView;
    NSNumber *storyId;
    NavigationViewController *navigationViewController;
    NSNumber *imageId;
    PhotoModel *photoModel;
}
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) NSNumber *storyId;
@property (nonatomic, retain) NSNumber *imageId;

- (void)showImage:(UIImage *)image;

@end
