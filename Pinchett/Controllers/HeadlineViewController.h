//
//  StoryView2Controller.h
//  Proto3
//
//  Created by kkar on 6/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewPhotoController.h"
#import "MBProgressHUD.h"
#import "NavigationViewController.h"
#import "PhotoViewController.h"
#import "NewTextViewController.h"
#import "HeadlineModel.h"
#import "PhotoModel.h"
#import "MapViewController.h"

#define kStoryViewImageTag 1
#define kStoryViewPhotoTagOffset 3000
#define kStoryViewTextTagOffset 4000

#define kStoryViewHeadlineTag 1
#define kStoryViewDateTag 2
#define kStoryViewLocationTag 3

#define kStoryViewButtonsPenTag 10
#define kStoryViewButtonsCameraTag 11

#define kBlockLayerBottom 10
#define kBlockLayer 11
#define kHUDLayer 1000

@interface HeadlineViewController : UIViewController <MBProgressHUDDelegate, ASIHTTPRequestDelegate, HeadlineRequestDelegate, PhotoDelegate> {
    NSNumber *storyId;
    MBProgressHUD *HUD;
    NSMutableArray *images;
    NSMutableArray *texts;
    CLLocationCoordinate2D location;
    NSInteger startTextCoordinate;
    NSInteger startImageCoordinate;
    NSInteger currentTextCoordinate;
    NSInteger currentImageCoordinate;
    NSString *headlineText;
    NSString *addressText;
    NSString *dateText;
    NSString *distanceText;
    UIScrollView *scrollView;
    NavigationViewController *navigationViewController;
    NSMutableArray *contentBlocks;
    BOOL initialized;
    HeadlineModel *headlineModel;
    PhotoModel *photoModel;
    BOOL shouldReloadContent;
    CFAbsoluteTime lastShown;
}

@property (nonatomic, retain) NSNumber *storyId;
@property (nonatomic, retain) NSString *headlineText;
@property (nonatomic, retain) NSString *addressText;
@property (nonatomic, retain) NSString *dateText;
@property (nonatomic, retain) NSString *distanceText;

- (void)drawView;

@end
