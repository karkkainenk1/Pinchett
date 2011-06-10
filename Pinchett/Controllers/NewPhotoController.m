//
//  NewPhotoController.m
//  Proto3
//
//  Created by kkar on 6/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NewPhotoController.h"

@implementation NewPhotoController
@synthesize storyId;
@synthesize controller;

- (id)init
{
    return [super init];
}

- (void)dealloc
{
    [storyId dealloc];
    [controller release];
    [super dealloc];
}

- (void)takePhoto
{
    photoModel = [[PhotoModel alloc] init];
    photoModel.delegate = self;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.delegate = self;
        [self.controller presentModalViewController:imagePickerController animated:YES];
        NSLog(@"Camera started");
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No camera" message:@"No camera found." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    HUD = [[MBProgressHUD alloc] initWithView:picker.view];
    HUD.labelText = @"Sending photo";
    picker.cameraOverlayView = HUD;
    [HUD show:YES];
    
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];

    [photoModel savePhoto:image longerSideLength:600 storyId:[self.storyId integerValue]];
}

#pragma mark - Photo saving delegate methods

- (void)savedPhoto
{
    [HUD show:NO];
    [imagePickerController dismissModalViewControllerAnimated:YES];
}

- (void)savingPhotoFailedWithMessage:(NSString *)message
{
    [HUD show:NO];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Photo" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
    [alert release];
    [imagePickerController dismissModalViewControllerAnimated:YES];
}

@end
