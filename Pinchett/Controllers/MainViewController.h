//
//  MainViewController.h
//  Proto3
//
//  Created by kkar on 6/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <math.h>
#import "NewPhotoController.h"
#import "NewTextViewController.h"
#import "UserModel.h"
#import "NewPhotoController.h"
#import "GPS.h"
#import "MBProgressHUD.h"
#import "HeadlineViewController.h"
#import "HeadlineViewController.h"
#import "PhotoViewController.h"
#import "NavigationViewController.h"
#import "UILabel+VerticalAlign.h"
#import "HeadlineModel.h"
#import "PhotoModel.h"
#import "MainViewCell.h"

#define kHeadlineTag 1
#define kAddressTag 2
#define kDistanceTag 3
#define kNewestTextTag 4
#define kImageTag 5
#define kNewTextButtonTag 6
#define kNewPhotoButtonTag 7
#define kLatestTextTag 8
#define kDateTag 9

#define kRowButtonTagOffset 1000
#define kCellTagOffset 2000

#define CELL_HEIGHT 146

#define MAX_HEADLINE_LENGTH 255

@interface MainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MBProgressHUDDelegate, HeadlineRequestDelegate, HeadlineSubmitDelegate, PhotoDelegate, UITextFieldDelegate> {
    UITableViewCell *myCell;
    UITableView *titleList;
    UIViewController *titleController;
    UIView *headerView;
    UITextField *headlineField;
    NSMutableArray *tableData;
    NSMutableDictionary *loadedImages;
    NewPhotoController *newPhotoController;
    BOOL fetchingCurrently;
    MBProgressHUD *HUD;
    HeadlineModel *headlineModel;
    PhotoModel *photoModel;
    CFAbsoluteTime lastShown;
    BOOL waitingForGps;
}

@property (nonatomic, retain) IBOutlet UITextField *headlineField;
@property (nonatomic, retain) IBOutlet UITableView *titleList;
@property (nonatomic, retain) IBOutlet UITableViewCell *myCell;
@property (nonatomic, retain) UIViewController *titleController;
@property (nonatomic, retain) IBOutlet UIView *headerView;
@property (nonatomic, retain) NSMutableArray *tableData;
@property (nonatomic, retain) NewPhotoController *newPhotoController;

@end
