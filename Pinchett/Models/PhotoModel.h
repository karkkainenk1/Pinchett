//
//  PhotoModel.h
//  Proto3
//
//  Created by Kimmo Kärkkäinen on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
#import "PhotoCache.h"
#import "UserModel.h"
#import "ASINetworkQueue.h"

@protocol PhotoDelegate <NSObject>
- (void)gotPhoto:(UIImage *)photo withInfo:(NSDictionary *)info;
- (void)gettingPhotoFailedWithMessage:(NSString *)message;
@end

@protocol PhotoSavingDelegate <NSObject>
- (void)savedPhoto;
- (void)savingPhotoFailedWithMessage:(NSString *)message;
@end

@interface PhotoModel : NSObject {
    UserModel *userModel;
    NSObject *delegate;
    ASINetworkQueue *queue;
}

@property (nonatomic, retain) NSObject *delegate;
@property (nonatomic, retain) ASINetworkQueue *queue;

- (void)getPhotoWithId:(NSInteger)photoId height:(NSInteger)height width:(NSInteger)width cut:(BOOL)cut info:(NSDictionary *)info;
- (void)savePhoto:(UIImage *)photo longerSideLength:(NSInteger)length storyId:(NSInteger)storyId;
- (void)cancelRequests;

@end
