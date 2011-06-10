//
//  Headline.m
//  Proto3
//
//  Created by Kimmo Kärkkäinen on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HeadlineModel.h"

@interface HeadlineModel (hidden)

- (void)gotHeadlineResponse:(ASIFormDataRequest *)request;
- (void)gettingHeadlinesFailed:(ASIFormDataRequest *)request;
- (void)headlineSubmitFinished:(ASIFormDataRequest *)request;
- (void)submittingHeadlineFailed:(ASIFormDataRequest *)request;
- (void)submittingHeadlineFailedWithMessage:(NSString *)message;

@end

@implementation HeadlineModel

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

#pragma mark - Getting headlines

// Gets headline data with texts and list of photos
- (void)getHeadlineWithId:(NSInteger)headlineId
{    
    NSString *urlString = [[NSString alloc] initWithFormat:@"http://itervide.futurice.com/proto/stories/getContentByStoryId/%d.json",headlineId];
    NSLog(@"Loading page %@", urlString);
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    [urlString release];
        
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setValue:self.delegate forKey:@"delegate"];
    request.userInfo = userInfo;
    [userInfo release];
    
    [url release];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(gotHeadlineResponse:)];
    [request setDidFailSelector:@selector(gettingHeadlinesFailed:)];
    
    NSString *deviceId = [[UIDevice currentDevice] uniqueIdentifier];
    NSNumber *userId = [userModel getUserId];
    [request setPostValue:userId forKey:@"data[Story][user_id]"];
    [request setPostValue:deviceId forKey:@"data[Story][device_id]"];
    
    [self.queue addOperation:request];
    [self.queue go];
}

// Gets closest headlines with one text and id of the most popular photo.
- (void)getHeadlines
{    
    NSLog(@"Get headlines");
    
    NSURL *url = [NSURL URLWithString:@"http://itervide.futurice.com/proto/stories/getLatestForLocation.json"];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setValue:self.delegate forKey:@"delegate"];
    request.userInfo = userInfo;
    [userInfo release];
    
    [request setPostValue:[[GPS sharedInstance] latitude] forKey:@"data[Story][latitude]"];
    [request setPostValue:[[GPS sharedInstance] longitude] forKey:@"data[Story][longitude]"];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(gotHeadlineResponse:)];
    [self.queue addOperation:request];
    [self.queue go];
}

// Getting headline(s) was successful
- (void)gotHeadlineResponse:(ASIFormDataRequest *)request
{
    NSString *response = [request responseString];
    NSLog(@"Response: %@", response);
    
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    NSObject *headlines = [[jsonParser objectWithString:response] objectForKey:@"data"];
    [jsonParser release];
    
    [delegate gotHeadlines:headlines];
}

// Connection to server failed
- (void)gettingHeadlinesFailed:(ASIFormDataRequest *)request
{
    [delegate gettingHeadlinesFailedWithMessage:@"Problem with internet connection.\nPlease try again later."];
}

#pragma mark - Submitting headline

// Start submitting given headline to server asynchronously
- (void)submitHeadline:(NSString *)headline
{
    NSString *deviceId = [[UIDevice currentDevice] uniqueIdentifier];
    NSNumber *userId = [userModel getUserId];
    
    NSURL *url = [NSURL URLWithString:@"http://itervide.futurice.com/proto/stories/add.json"];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setValue:self.delegate forKey:@"delegate"];
    request.userInfo = userInfo;
    [userInfo release];
    
    [request setPostValue:userId forKey:@"data[Story][user_id]"];
    [request setPostValue:deviceId forKey:@"data[Story][device_id]"];
    [request setPostValue:headline forKey:@"data[Story][headline]"];
    [request setPostValue:[[GPS sharedInstance] latitude] forKey:@"data[Story][latitude]"];
    [request setPostValue:[[GPS sharedInstance] longitude] forKey:@"data[Story][longitude]"];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(headlineSubmitFinished:)];
    [request setDidFailSelector:@selector(submittingHeadlineFailed:)];
    [self.queue addOperation:request];
    [self.queue go];
}

// Submitted headline to server, handle success/failure
- (void)headlineSubmitFinished:(ASIFormDataRequest *)request
{
    NSString *response = [request responseString];
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    NSDictionary *responseDictionary = [jsonParser objectWithString:response];
    [jsonParser release];
    
    NSNumber *successNum = [responseDictionary objectForKey:@"success"];
    BOOL success = [successNum boolValue];
    if (success) {
        [self gotHeadlineResponse:request];
    } else {
        NSString *errorMessage = [responseDictionary objectForKey:@"message"];
        [self submittingHeadlineFailedWithMessage:errorMessage];
    }
}

// Connection to server failed
- (void)submittingHeadlineFailed:(ASIFormDataRequest *)request
{
    [self submittingHeadlineFailedWithMessage:@"Problem with internet connection.\nPlease try again later."];
}

// Sending headline failed so we send an error message to the delegate
- (void)submittingHeadlineFailedWithMessage:(NSString *)message
{
    NSObject<HeadlineSubmitDelegate> *myDelegate = (NSObject<HeadlineSubmitDelegate> *)delegate;
    [myDelegate submittingHeadlineFailedWithMessage:message];
}

// Cancel all requests from queue and unset their delegates
- (void)cancelRequests
{
    for (ASIHTTPRequest *req in [self.queue operations])
    {
        [req clearDelegatesAndCancel];
    }
}

@end
