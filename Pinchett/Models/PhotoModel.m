//
//  PhotoModel.m
//  Proto3
//
//  Created by Kimmo Kärkkäinen on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PhotoModel.h"

@interface PhotoModel (hidden)

- (void)gotPhotoResponse:(ASIFormDataRequest *)request;
- (void)gettingPhotoFailed:(ASIFormDataRequest *)request;
- (void)gotPhoto:(UIImage *)photo withInfo:(NSDictionary *)info;
- (UIImage *)resizeImage:(UIImage *)image newSize:(NSInteger)newSize;
- (void)uploadPhoto:(UIImage *)photo storyId:(NSInteger)storyId;
- (void)uploadedPhoto:(ASIFormDataRequest *)request;
- (void)uploadingPhotoFailed:(ASIFormDataRequest *)request;
- (void)uploadingPhotoFailedWithMessage:(NSString *)message;

@end

@implementation PhotoModel

@synthesize delegate;
@synthesize queue;

- (id)init
{
    userModel = [[UserModel alloc] init];
    self.queue = [[ASINetworkQueue alloc] init];
    return [super init];
}

- (void)dealloc
{
    [userModel release];
    [self cancelRequests];
    [super dealloc];
}

#pragma mark - Handle getting photo

// Check if we already have cached version of wanted photo and if we don't,
// get it from the server asynchronously.
- (void)getPhotoWithId:(NSInteger)photoId height:(NSInteger)height width:(NSInteger)width cut:(BOOL)cut info:(NSDictionary *)info
{   
    if (photoId < 1) return;
    
    PhotoCache *cache = [PhotoCache sharedInstance];
    
    UIImage *cached = [cache getCachedPhoto:[NSString stringWithFormat:@"%d-%dx%d-%d.jpg",photoId,width,height,cut]];
    
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithDictionary:info];
    
    [userInfo setValue:[NSNumber numberWithInt:photoId] forKey:@"photoId"];
    [userInfo setValue:[NSNumber numberWithInt:width] forKey:@"width"];
    [userInfo setValue:[NSNumber numberWithInt:height] forKey:@"height"];
    [userInfo setValue:[NSNumber numberWithInt:cut] forKey:@"cut"];
    [userInfo setValue:self.delegate forKey:@"delegate"];
    
    if(cached == nil) {
        NSString *urlString;
        if (cut) {
            urlString = [[NSString alloc] initWithFormat:@"http://itervide.futurice.com/proto/images/getScaledAndCutImageByImageId/%d",photoId];
        } else {
            urlString = [[NSString alloc] initWithFormat:@"http://itervide.futurice.com/proto/images/getScaledImageByImageId/%d",photoId];
        }
        NSURL *url = [[NSURL alloc] initWithString:urlString];
        [urlString release];
        ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
        [url release];
        
        request.userInfo = userInfo;
        request.delegate = self;
        
        NSString *deviceId = [[UIDevice currentDevice] uniqueIdentifier];
        NSNumber *userId = [userModel getUserId];
        [request setPostValue:userId forKey:@"data[Image][user_id]"];
        [request setPostValue:deviceId forKey:@"data[Image][device_id]"];
        
        [request setDidFinishSelector:@selector(gotPhotoResponse:)];
        [request setDidFailSelector:@selector(gettingPhotoFailed:)];
                
        [request setPostValue:[NSNumber numberWithInt:width] forKey:@"data[Image][width]"];
        [request setPostValue:[NSNumber numberWithInt:height] forKey:@"data[Image][height]"];
        [self.queue addOperation:request];
        [self.queue go];
        NSLog(@"Started request");
        [request release];
    } else {
        [self gotPhoto:cached withInfo:userInfo];
    }
         
    [userInfo release];
}

// We got photo response from server, handle received data
- (void)gotPhotoResponse:(ASIFormDataRequest *)request
{
    NSLog(@"Got image with size %d", [[request responseData] length]);
    
    NSInteger photoId = [[request.userInfo objectForKey:@"photoId"] integerValue];
    NSInteger width = [[request.userInfo objectForKey:@"width"] integerValue];
    NSInteger height = [[request.userInfo objectForKey:@"height"] integerValue];
    NSInteger cut = [[request.userInfo objectForKey:@"cut"] integerValue];
    
    [[PhotoCache sharedInstance] cachePhotoData:[request responseData] filename:[NSString stringWithFormat:@"%d-%dx%d-%d.jpg",photoId,width,height,cut]];
    
    NSData *responseData = [request responseData];
    UIImage *photo = [UIImage imageWithData:responseData];
    
    [self gotPhoto:photo withInfo:request.userInfo];
}

// We got the photo (from cache or server), so send it to the delegate
- (void)gotPhoto:(UIImage *)photo withInfo:(NSDictionary *)info
{
    NSObject<PhotoDelegate> *myDelegate = (NSObject<PhotoDelegate> *)delegate;
    [myDelegate gotPhoto:photo withInfo:info];
}

// Connection to server failed, inform the delegate
- (void)gettingPhotoFailed:(ASIFormDataRequest *)request
{
    NSObject<PhotoDelegate> *myDelegate = (NSObject<PhotoDelegate> *)delegate;
    [myDelegate gettingPhotoFailedWithMessage:@"Connection to server failed"];
}

#pragma mark - Handle saving photo

// Handle sending a new photo to the server.
- (void)savePhoto:(UIImage *)photo longerSideLength:(NSInteger)length storyId:(NSInteger)storyId
{
    UIImage *newPhoto = [self resizeImage:photo newSize:600];    
    [self uploadPhoto:newPhoto storyId:storyId];
}

// Upload the resized photo to the server
- (void)uploadPhoto:(UIImage *)photo storyId:(NSInteger)storyId
{
    NSData *photoData = UIImageJPEGRepresentation(photo, 0.8);
    
    NSURL *url = [[NSURL alloc] initWithString:@"http://itervide.futurice.com/proto/images/add.json"];
    
    NSString *deviceId = [[UIDevice currentDevice] uniqueIdentifier];
    
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    [url release];
    
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    request.userInfo = userInfo;
    [userInfo release];
    
    request.delegate = self;
    [request setDidFinishSelector:@selector(uploadedPhoto:)];
    [request setDidFailSelector:@selector(uploadingPhotoFailed:)];
    
    [request setData:photoData withFileName:@"photo.jpg" andContentType:@"image/jpeg" forKey:@"data[File]"];
    [request setPostValue:[userModel getUserId] forKey:@"data[Image][user_id]"];
    [request setPostValue:deviceId forKey:@"data[Image][device_id]"];
    [request setPostValue:[NSNumber numberWithInt:storyId] forKey:@"data[Image][story_id]"];
    [self.queue addOperation:request];
    [self.queue go];
    [request release];
}

// Uploading photo to server finished, handle success
- (void)uploadedPhoto:(ASIFormDataRequest *)request
{
    NSString *response = [request responseString];
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    NSDictionary *responseDictionary = [jsonParser objectWithString:response];
    [jsonParser release];
    
    NSNumber *successNum = [responseDictionary objectForKey:@"success"];
    BOOL success = [successNum boolValue];
    if (success) {
        NSObject<PhotoSavingDelegate> *myDelegate = (NSObject<PhotoSavingDelegate> *)delegate;
        [myDelegate savedPhoto];
    } else {
        NSString *errorMessage = [responseDictionary objectForKey:@"message"];
        [self uploadingPhotoFailedWithMessage:errorMessage];
    }
}

// Connection to server failed
- (void)uploadingPhotoFailed:(ASIFormDataRequest *)request
{
    [self uploadingPhotoFailedWithMessage:@"Problem with internet connection.\nPlease try again later."];
}

// Inform the delegate about failure
- (void)uploadingPhotoFailedWithMessage:(NSString *)message
{
    NSObject<PhotoSavingDelegate> *myDelegate = (NSObject<PhotoSavingDelegate> *)delegate;
    [myDelegate savingPhotoFailedWithMessage:message];
}

// Remove requests from queue and unset their delegates.
- (void)cancelRequests
{
    for (ASIHTTPRequest *req in [self.queue operations])
    {
        [req clearDelegatesAndCancel];
    }
}

#pragma mark - Manipulating photo

- (UIImage *)resizeImage:(UIImage *)image newSize:(NSInteger)newSize
{
    int kMaxResolution = newSize; // Or whatever
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = bounds.size.width / ratio;
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

@end
