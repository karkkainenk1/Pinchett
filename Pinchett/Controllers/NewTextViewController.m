//
//  NewTextViewController.m
//  Proto3
//
//  Created by kkar on 6/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NewTextViewController.h"

@implementation NewTextViewController
@synthesize myTextField;
@synthesize textFieldUsedLengthLabel;
@synthesize storyId;
@synthesize headlineText;
@synthesize addressText;
@synthesize dateText;
@synthesize distanceText;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithId:(NSNumber *)story;
{
    self.storyId = story;
    return [super init];
}

- (void)dealloc
{
    [myTextField release];
    [HUD release];
    [navigationViewController release];
    [headlineText release];
    [addressText release];
    [dateText release];
    [distanceText release];
    [textModel release];
    [textFieldUsedLengthLabel release];
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
    
    textModel = [[TextModel alloc] init];
    textModel.delegate = self;
    
    [self drawHeader];
    
    navigationViewController = [[NavigationViewController alloc] init];
    navigationViewController.controller = self;
    [self.view addSubview:navigationViewController.view];
    
    self.myTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, startCoordinate, 300, 31)];
    self.myTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.myTextField.font = [UIFont fontWithName:@"Helvetica" size:12];
    self.myTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.myTextField.placeholder = @"Add text";
    self.myTextField.returnKeyType = UIReturnKeySend;
    self.myTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.myTextField addTarget:self action:@selector(sendText:) forControlEvents:UIControlEventEditingDidEndOnExit];
    self.myTextField.delegate = self;
    [self.view addSubview:self.myTextField];
    
    [self.myTextField becomeFirstResponder];
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.delegate = self;
    HUD.yOffset = -60;
    
    textFieldUsedLengthLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, startCoordinate+35, 300, 14)];
    textFieldUsedLengthLabel.textColor = [UIColor lightGrayColor];
    textFieldUsedLengthLabel.backgroundColor = [UIColor colorWithRed:236.0f/255 green:228.0f/255 blue:234.0f/255 alpha:1.0f];
    textFieldUsedLengthLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
    textFieldUsedLengthLabel.text = @"0 / 247";
    [self.view addSubview:textFieldUsedLengthLabel];
    
    sendingText = NO;
}

- (void)viewDidUnload
{
    [textModel cancelRequests];
    HUD.delegate = nil;
    [self setMyTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Drawing GUI

- (void)drawHeader
{
    NSLog(@"Draw header happened");
    
    CGSize headlineSize = [headlineText sizeWithFont:[UIFont fontWithName:@"Helvetica" size:22] constrainedToSize:CGSizeMake(280, 60) lineBreakMode:UILineBreakModeWordWrap];
    NSInteger headlineHeight = headlineSize.height;
    NSInteger totalHeight = headlineHeight+45;
    startCoordinate = totalHeight+82;
    
    NSLog(@"Headline height: %d", headlineHeight);
    NSLog(@"Total height: %d", totalHeight);
    NSLog(@"StartImageCoordinate: %d", startCoordinate);
    
    UIView *shadowView = [[UIView alloc] initWithFrame:CGRectMake(13, 63, 300, totalHeight)];
    [shadowView setBackgroundColor:[UIColor colorWithRed:201.0f/255 green:187.0f/255 blue:199.0f/255 alpha:1.0f]];
    [self.view addSubview:shadowView];
    [shadowView release];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(10, 60, 300, totalHeight)];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *headlineLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 5, 280, headlineHeight)];
    headlineLabel.lineBreakMode = UILineBreakModeWordWrap;
    headlineLabel.numberOfLines = 2;
    headlineLabel.font = [UIFont fontWithName:@"Helvetica" size:22];
    headlineLabel.text = headlineText;
    [headerView addSubview:headlineLabel];
    [headlineLabel release];
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, headlineHeight+6, 280, 16)];
    dateLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    dateLabel.textColor = [UIColor lightGrayColor];
    dateLabel.text = dateText;
    [headerView addSubview:dateLabel];
    [dateLabel release];
    
    UILabel *distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, headlineHeight+23, 280, 16)];
    distanceLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    distanceLabel.textColor = [UIColor lightGrayColor];
    distanceLabel.text = addressText;
    distanceLabel.text = [distanceLabel.text stringByAppendingString:@", "];
    distanceLabel.text = [distanceLabel.text stringByAppendingString:distanceText];
    [headerView addSubview:distanceLabel];
    [distanceLabel release];
    
    [self.view addSubview:headerView];
    [headerView release];
    
    UIImageView *separatorView = [[UIImageView alloc] initWithFrame:CGRectMake(0, totalHeight+72, 320, 1)];
    NSString *separatorPath = [[NSBundle mainBundle] pathForResource:@"separator" ofType:@"png"];
    [separatorView setImage:[UIImage imageWithContentsOfFile:separatorPath]];
    [self.view addSubview:separatorView];
    [separatorView release];
}
 
#pragma mark - Handle sending text

- (IBAction)sendText:(id)sender {
    sendingText = YES;
    
    [self.navigationController.view addSubview:HUD];
    HUD.labelText = @"Sending text";
    [HUD show:YES];
    
    [textModel sendText:self.myTextField.text storyId:[self.storyId integerValue]];
}

#pragma mark - Text sending delegate methods

- (void)sentText
{
    sendingText = NO;
    
    [HUD hide:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sendingTextFailedWithMessage:(NSString *)message
{
    sendingText = NO;
    
    [HUD hide:YES];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Text" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

#pragma mark - HUD Delegate methods

- (void)hudWasHidden
{
    [HUD removeFromSuperview];
}

#pragma mark - Text Field delegate methods

// Limit text fields maximum length
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    BOOL shouldChange = (newLength <= MAX_TEXT_LENGTH);
    
    if (shouldChange) {
        textFieldUsedLengthLabel.text = [NSString stringWithFormat:@"%d / 247", newLength];
    }
    
    return shouldChange;
}

// We don't want to hide the keyboard, so we don't let it to return
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (!sendingText) {
        [self sendText:textField];
    }
    return NO;
}

@end
