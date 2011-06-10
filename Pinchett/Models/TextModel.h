//
//  TextModel.h
//  Proto3
//
//  Created by Kimmo Kärkkäinen on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"
#import "UserModel.h"

@protocol TextSendingDelegate <NSObject>
- (void)sentText;
- (void)sendingTextFailedWithMessage:(NSString *)message;
@end

@interface TextModel : NSObject {
    NSObject<TextSendingDelegate> *delegate;
    ASINetworkQueue *queue;
    UserModel *userModel;
}

@property (nonatomic, retain) NSObject<TextSendingDelegate> *delegate;
@property (nonatomic, retain) ASINetworkQueue *queue;

- (void)sendText:(NSString *)text storyId:(NSInteger)storyId;
- (void)cancelRequests;

@end
