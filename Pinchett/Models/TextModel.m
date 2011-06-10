//
//  TextModel.m
//  Proto3
//
//  Created by Kimmo Kärkkäinen on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TextModel.h"

@interface TextModel (hidden)
- (void)sentText:(ASIFormDataRequest *)request;
- (void)sendingTextFailed:(ASIFormDataRequest *)request;
- (void)sendingTextFailedWithMessage:(NSString *)message;
@end


@implementation TextModel

@synthesize queue;
@synthesize delegate;

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

#pragma mark - Handle sending text

// Send new text to server
- (void)sendText:(NSString *)text storyId:(NSInteger)storyId
{
    NSString *deviceId = [[UIDevice currentDevice] uniqueIdentifier];
    
    NSURL *url = [[NSURL alloc] initWithString:@"http://itervide.futurice.com/proto/texts/add.json"];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [url release];
    
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    request.userInfo = userInfo;
    [userInfo release];
    
    [request setPostValue:[userModel getUserId] forKey:@"data[Text][user_id]"];
    [request setPostValue:deviceId forKey:@"data[Text][device_id]"];
    [request setPostValue:text forKey:@"data[Text][content]"];
    [request setPostValue:[NSNumber numberWithInt:storyId] forKey:@"data[Text][story_id]"];
    
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(sentText:)];
    [request setDidFailSelector:@selector(sendingTextFailed:)];
    
    [self.queue addOperation:request];
    [self.queue go];
}

// Sending text to server finished, handle success
- (void)sentText:(ASIFormDataRequest *)request
{
    NSString *response = [request responseString];
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    NSDictionary *responseDictionary = [jsonParser objectWithString:response];
    [jsonParser release];
    
    NSNumber *successNum = [responseDictionary objectForKey:@"success"];
    BOOL success = [successNum boolValue];
    if (success) {
        [delegate sentText];
    } else {
        NSString *errorMessage = [responseDictionary objectForKey:@"message"];
        [self sendingTextFailedWithMessage:errorMessage];
    }
}

// Connection to server failed
- (void)sendingTextFailed:(ASIFormDataRequest *)request
{
    [delegate sendingTextFailedWithMessage:@"Problem with internet connection.\nPlease try again later."];
}

// Inform the delegate about failure
- (void)sendingTextFailedWithMessage:(NSString *)message
{
    [delegate sendingTextFailedWithMessage:message];
}

// Remove all requests from queue and unset their delegates
- (void)cancelRequests
{
    for (ASIHTTPRequest *req in [self.queue operations])
    {
        [req clearDelegatesAndCancel];
    }
}


@end
