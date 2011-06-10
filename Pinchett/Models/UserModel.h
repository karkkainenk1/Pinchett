//
//  User.h
//  Proto3
//
//  Created by kkar on 6/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"
#import "SBJsonParser.h"

@protocol LoginDelegate
- (void)loginSucceeded;
- (void)loginFailedWithMessage:(NSString *)message;
@end

@interface UserModel : NSObject {
    NSObject<LoginDelegate> *delegate;
    ASINetworkQueue *queue;
}

@property (nonatomic, retain) NSObject<LoginDelegate> *delegate;
@property (nonatomic, retain) ASINetworkQueue *queue;

- (void)setUsername:(NSString *)username userId:(NSNumber *)userid;
- (NSNumber *)getUserId;
- (NSString *)getUserName;
- (BOOL)isLogged;
- (void)loginWithUsername:(NSString *)username;
- (void)cancelRequests;

@end