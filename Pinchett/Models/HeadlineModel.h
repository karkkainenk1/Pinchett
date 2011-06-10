//
//  Headline.h
//  Proto3
//
//  Created by Kimmo Kärkkäinen on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
#import "GPS.h"
#import "SBJsonParser.h"
#import "UserModel.h"
#import "ASINetworkQueue.h"

@protocol HeadlineRequestDelegate <NSObject>
- (void)gotHeadlines:(NSObject *)headlines;
- (void)gettingHeadlinesFailedWithMessage:(NSString *)message;
@end

@protocol HeadlineSubmitDelegate <NSObject>
- (void)submittingHeadlineFailedWithMessage:(NSString *)message;
@end

@interface HeadlineModel : NSObject {
    NSObject<HeadlineRequestDelegate> *delegate;
    ASINetworkQueue *queue;
    UserModel *userModel;
}

@property (nonatomic, retain) NSObject<HeadlineRequestDelegate> *delegate;
@property (nonatomic, retain) ASINetworkQueue *queue;

- (void)getHeadlines;
- (void)getHeadlineWithId:(NSInteger)headlineId;
- (void)submitHeadline:(NSString *)headline;
- (void)cancelRequests;

@end
