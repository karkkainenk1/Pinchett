//
//  LoginViewController.h
//  Proto3
//
//  Created by kkar on 6/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "UserModel.h"
#import "MBProgressHUD.h"

#define MAX_LOGIN_LENGTH 40

@interface LoginViewController : UIViewController <MBProgressHUDDelegate, ASIHTTPRequestDelegate, LoginDelegate, UITextFieldDelegate> {
    UITextField *reporterName;
    MBProgressHUD *HUD;
    UserModel *user;
}
@property (nonatomic, retain) IBOutlet UITextField *reporterName;

- (IBAction)startLogin:(id)sender;

@end
