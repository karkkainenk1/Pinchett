//
//  NewPhotoController.h
//  Proto3
//
//  Created by kkar on 6/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "UserModel.h"
#import "HeadlineViewController.h"
#import "PhotoModel.h"

@interface NewPhotoController : NSObject <UIImagePickerControllerDelegate, UINavigationControllerDelegate, ASIHTTPRequestDelegate, PhotoSavingDelegate> {
    NSNumber *storyId;
    UIViewController *controller;
    MBProgressHUD *HUD;
    UIImagePickerController *imagePickerController;
    long long totalBytes;
    long long sentBytes;
    NSAutoreleasePool *pool;
    PhotoModel *photoModel;
}

@property (nonatomic, retain) NSNumber *storyId;
@property (nonatomic, retain) UIViewController *controller;

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
- (void)takePhoto;
- (id)init;

@end
