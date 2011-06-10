//
//  PhotoViewController.m
//  Proto3
//
//  Created by kkar on 6/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PhotoViewController.h"


@implementation PhotoViewController
@synthesize scrollView;
@synthesize storyId;
@synthesize imageId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"Dealloc");
    [imageId release];
    [HUD release];
    [scrollView release];
    [storyId release];
    [navigationViewController release];
    [photoModel release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    navigationViewController = [[NavigationViewController alloc] init];
    navigationViewController.controller = self;
    [self.view addSubview:navigationViewController.view];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.delegate = self;
    HUD.labelText = @"Loading photo";
    [self.view addSubview:HUD];
    [HUD show:YES];
    
    photoModel = [[PhotoModel alloc] init];
    photoModel.delegate = self;
    
    [photoModel getPhotoWithId:[imageId integerValue] height:600 width:600 cut:NO info:nil];
}

- (void)viewDidUnload
{    
    [self setScrollView:nil];
    
    HUD.delegate = nil;
    [HUD hide:YES];
    
    [super viewDidUnload];
}

#pragma mark - Photo delegate methods

- (void)gotPhoto:(UIImage *)photo withInfo:(NSDictionary *)info
{
    [HUD hide:YES];
    [self showImage:photo];
}

- (void)gettingPhotoFailedWithMessage:(NSString *)message
{
    [HUD hide:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Photo" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

#pragma mark - Showing image

- (void)showImage:(UIImage *)image
{
    imageView = [[UIImageView alloc] initWithImage:image];
    [self.scrollView addSubview:imageView];
    [self.scrollView setContentSize:[image size]];
    if (image.size.width > image.size.height) {
        [self.scrollView setMinimumZoomScale:0.4f];
        [self.scrollView setZoomScale:0.4f];
    } else {
        [self.scrollView setMinimumZoomScale:0.5f];
        [self.scrollView setZoomScale:0.5f];
    }
    [imageView release];
    [HUD hide:YES];
}

#pragma mark - UIScrollView Delegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView;
}

#pragma mark - HUD Delegate methods

- (void)hudWasHidden {
    [HUD removeFromSuperview];
}

@end
