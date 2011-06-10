//
//  User.m
//  Proto3
//
//  Created by kkar on 6/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UserModel.h"


@interface UserModel (hidden)
- (void)gotLoginResponse:(ASIHTTPRequest *)request;
- (void)failedToGetLoginResponse:(ASIHTTPRequest *)request;
@end


@implementation UserModel

@synthesize delegate;
@synthesize queue;

- (id)init
{
    self.queue = [[ASINetworkQueue alloc] init];
    return [super init];
}

- (void)dealloc
{
    [self cancelRequests];
    [super dealloc];
}

// Store username and user id in program preferences
- (void)setUsername:(NSString *)username userId:(NSNumber *)userid
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:userid forKey:@"userid"];
    [prefs setObject:username forKey:@"username"];
    [prefs synchronize];
}

// Get user id from program preferences
- (NSNumber *)getUserId
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    return (NSNumber *)[prefs objectForKey:@"userid"];
}

// Get username from program preferences
- (NSString *)getUserName
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    return (NSString *)[prefs objectForKey:@"username"];
}

// Check if user has userid in preferences
- (BOOL)isLogged
{
    if([self getUserId] != nil) {
        return YES;
    } else {
        return NO;
    }
}

// Start logging in to server (asynchronously)
- (void)loginWithUsername:(NSString *)username
{
    NSURL *url = [NSURL URLWithString:@"http://itervide.futurice.com/proto/users/add.json"];
    NSString *deviceId = [[UIDevice currentDevice] uniqueIdentifier];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setValue:username forKey:@"username"];
    request.userInfo = userInfo;
    [userInfo release];
    
    [request setPostValue:username forKey:@"data[User][name]"];
    [request setPostValue:deviceId forKey:@"data[User][device_id]"];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(gotLoginResponse:)];
    [request setDidFailSelector:@selector(failedToGetLoginResponse:)];
    [self.queue addOperation:request];
    [self.queue go];
}

// Server gave us response to login request
- (void)gotLoginResponse:(ASIHTTPRequest *)request
{
    NSLog(@"Got login response");
    
    NSString *response = [request responseString];
    
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    NSDictionary *responseData = [jsonParser objectWithString:response];
    [jsonParser release];
    
    NSNumber *successNum = [responseData objectForKey:@"success"];
    BOOL success = [successNum boolValue];
    if(!success) {
        [delegate loginFailedWithMessage:[responseData objectForKey:@"message"]];
    } else {
        NSString *username = [request.userInfo objectForKey:@"username"];
        NSNumber *userid = [responseData objectForKey:@"user_id"];
        [self setUsername:username userId:userid];
        
        [delegate loginSucceeded];
    }
}

// Failed to connect our server
- (void)failedToGetLoginResponse:(ASIHTTPRequest *)request
{
    NSLog(@"Failed to get login response");
    
    [delegate loginFailedWithMessage:@"Connection to server failed."];
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
