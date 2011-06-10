//
//  LoginViewController.m
//  Proto3
//
//  Created by kkar on 6/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"

@implementation LoginViewController
@synthesize reporterName;

- (void)dealloc
{
    [user release];
    [reporterName release];
    [HUD release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    user = [[UserModel alloc] init];
    user.delegate = self;
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    HUD.delegate = self;
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    // If user is already logged in, move to main view, otherwise
    // show this login view
    if([user isLogged]) {
        MainViewController *mainViewController = [[MainViewController alloc] init];
        [self.navigationController pushViewController:mainViewController animated:YES];
        [mainViewController release];
    } else {
        self.reporterName.borderStyle = UITextBorderStyleRoundedRect;
        self.reporterName.delegate = self;
    }
    
}
    
- (void)viewDidUnload
{
    [self setReporterName:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - Login methods

- (IBAction)startLogin:(id)sender {
    [self.navigationController.view addSubview:HUD];
    HUD.labelText = @"Logging in";
    [HUD show:YES];
    
    [sender resignFirstResponder];

    [user loginWithUsername:reporterName.text];
}

#pragma mark - HUD Delegate methods

- (void)hudWasHidden {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
}

#pragma mark - Login delegate methods

- (void)loginSucceeded
{
    [HUD hide:YES];
    MainViewController *mainViewController = [[MainViewController alloc] init];
    [self.navigationController pushViewController:mainViewController animated:YES];
    [mainViewController release];
}

- (void)loginFailedWithMessage:(NSString *)message
{
    [HUD hide:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];   
    [alert release];
}

#pragma mark - Text Field delegate methods

// Limit the maximum size of the login field
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > MAX_LOGIN_LENGTH) ? NO : YES;
}

@end
