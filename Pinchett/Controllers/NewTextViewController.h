//
//  NewTextViewController.h
//  Proto3
//
//  Created by kkar on 6/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "UserModel.h"
#import "MBProgressHUD.h"
#import "HeadlineViewController.h"
#import "NavigationViewController.h"
#import "TextModel.h"

#define MAX_TEXT_LENGTH 247

@interface NewTextViewController : UIViewController <MBProgressHUDDelegate, TextSendingDelegate, UITextFieldDelegate> {
    UITextField *myTextField;
    UILabel *textFieldUsedLengthLabel;
    NSNumber *storyId;
    MBProgressHUD *HUD;
    NavigationViewController *navigationViewController;
    NSString *headlineText;
    NSString *addressText;
    NSString *dateText;
    NSString *distanceText;
    NSInteger startCoordinate;
    TextModel *textModel;
    BOOL sendingText;
}
@property (nonatomic, retain) IBOutlet UITextField *myTextField;
@property (nonatomic, retain) IBOutlet UILabel *textFieldUsedLengthLabel;
@property (nonatomic, retain) NSNumber *storyId;
@property (nonatomic, retain) NSString *headlineText;
@property (nonatomic, retain) NSString *addressText;
@property (nonatomic, retain) NSString *dateText;
@property (nonatomic, retain) NSString *distanceText;

- (IBAction)sendText:(id)sender;
- (id)initWithId:(NSNumber *)story;
- (void)drawHeader;

@end
