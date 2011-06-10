//
//  MainViewController.m
//  Proto3
//
//  Created by kkar on 6/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController (hidden)
- (IBAction)submitHeadline:(id)sender;
- (void)fetchHeadlines;
- (IBAction)newTextButtonPressed:(id)sender;
- (IBAction)newPhotoButtonPressed:(id)sender;
- (void)showHudWithDescription:(NSString *)description;
- (void)getPhotoForRow:(NSNumber *)row;
- (void)showImage:(UIImage *)image inRowWithTag:(NSInteger)tag;
- (void)rowPhotoButtonPressed:(id)sender;
- (NSInteger)getImageIdForRow:(NSInteger)row;
- (NSInteger)getStoryIdForRow:(NSInteger)row;
- (void)handleGpsFail;
@end

@implementation MainViewController
@synthesize headlineField;
@synthesize titleList;
@synthesize titleController;
@synthesize headerView;
@synthesize myCell;
@synthesize tableData;
@synthesize newPhotoController;

- (void)dealloc
{
    [loadedImages release];
    [titleController release];
    [titleList release];
    [myCell release];
    [headerView release];
    [headlineField release];
    [tableData release];
    [newPhotoController release];
    [HUD release];
    [headlineModel release];
    [photoModel release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.delegate = self;
    
    headlineModel = [[HeadlineModel alloc] init];
    headlineModel.delegate = self;
    
    photoModel = [[PhotoModel alloc] init];
    photoModel.delegate = self;
    
    // We use our custom navigation view, so initialize that
    NavigationViewController *navigationViewController = [[NavigationViewController alloc] init];
    navigationViewController.controller = self;
    [self.view addSubview:navigationViewController.view];
    UIButton *backButton = (UIButton *)[navigationViewController.view viewWithTag:kBackButton];
    [backButton setHidden:YES];
    [navigationViewController release];
    
    loadedImages = [[NSMutableDictionary alloc] init];
    self.tableData = [[NSMutableArray alloc] initWithCapacity:0];
    fetchingCurrently = false;
        
    // If we get new location, update headlines. This makes it possible
    // for us to wait for GPS data to be accurate enough before we show 
    // anything.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchHeadlines) name:@"locationUpdate" object:nil];
    
    self.titleList.tableHeaderView = self.headerView;
    
    self.titleList.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.headlineField.borderStyle = UITextBorderStyleRoundedRect;
    self.headlineField.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [HUD removeFromSuperview];
    
    if (CFAbsoluteTimeGetCurrent() - lastShown > 900) {
        [self.tableData removeAllObjects];
        [self.titleList reloadData];
    }
    
    headlineModel = [[HeadlineModel alloc] init];
    headlineModel.delegate = self;
    
    if([[GPS sharedInstance] locationKnown] || (CFAbsoluteTimeGetCurrent() - lastShown < 900 && [GPS sharedInstance].latitude != nil)) {
        [self fetchHeadlines];
    } else {
        NSLog(@"Location not known");
        [self showHudWithDescription:@"Waiting for GPS signal"];
        waitingForGps = YES;
        [NSThread detachNewThreadSelector:@selector(handleGpsFail) toTarget:self withObject:nil];
    }
    [super viewWillAppear:animated];
    
    lastShown = CFAbsoluteTimeGetCurrent();
}

- (void)viewWillDisappear:(BOOL)animated
{
    [HUD removeFromSuperview];
    [super viewWillDisappear:animated];
}


- (void)viewDidUnload
{
    HUD.delegate = nil;
    [self setMyCell:nil];
    [self setHeadlineField:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [tableData release];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - Table view data source methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Drawing cell");
    
    NSUInteger row = indexPath.row;
    
    NSDictionary *rowData = [self.tableData objectAtIndex:row];
    NSDictionary *rowStory = [rowData objectForKey:@"Story"];
    
    NSString *cellIdentifier = @"MainViewCellIdentifier";
    
    MainViewCell *cell = (MainViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[[MainViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier selected:YES] autorelease];
        
        // Create latest text label
        UILabel *latestText = [[UILabel alloc] initWithFrame:CGRectMake(83, 54, 156, 61)];
        [latestText setFont:[UIFont fontWithName:@"Helvetica" size:14.0f]];
        [latestText setTextColor:[UIColor darkGrayColor]];
        [latestText setLineBreakMode:UILineBreakModeWordWrap];
        [latestText setNumberOfLines:3];
        [latestText setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:0.0f]];
        latestText.tag = kLatestTextTag;
        [cell addSubview:latestText];
        [latestText release];
        
        // Initialize new text button
        UIButton *newTextButton = [[UIButton alloc] initWithFrame:CGRectMake(247, 14, 60, 60)];
        newTextButton.tag = kNewTextButtonTag;
        [newTextButton setContentMode:UIViewContentModeCenter];
        NSString *penPath = [[NSBundle mainBundle] pathForResource:@"pen" ofType:@"png"];
        UIImage *penImage = [UIImage imageWithContentsOfFile:penPath];
        [newTextButton setImage:penImage forState:UIControlStateNormal];
        [newTextButton addTarget:self action:@selector(newTextButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:newTextButton];
        [newTextButton release];
        
        // Initialize new photo button
        UIButton *newPhotoButton = [[UIButton alloc] initWithFrame:CGRectMake(247, 74, 60, 60)];
        newPhotoButton.tag = kNewPhotoButtonTag;
        [newPhotoButton setContentMode:UIViewContentModeCenter];
        NSString *cameraPath = [[NSBundle mainBundle] pathForResource:@"camera" ofType:@"png"];
        UIImage *cameraImage = [UIImage imageWithContentsOfFile:cameraPath];
        [newPhotoButton setImage:cameraImage forState:UIControlStateNormal];
        [newPhotoButton addTarget:self action:@selector(newPhotoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:newPhotoButton];
        [newPhotoButton release];
        
        // Initialize row photo
        UIButton *rowPhotoButton = [[UIButton alloc] initWithFrame:CGRectMake(18, 55, 60, 60)];
        rowPhotoButton.tag = kImageTag;
        [rowPhotoButton setContentMode:UIViewContentModeCenter];
        [cell addSubview:rowPhotoButton];
        [rowPhotoButton release];
    }
    
    // Set row photo contents and actions
    UIButton *rowPhotoButton = (UIButton *)[cell viewWithTag:kImageTag];
    
    NSString *thumbPath = [[NSBundle mainBundle] pathForResource:@"default-thumb" ofType:@"png"];
    UIImage *thumbImage = [UIImage imageWithContentsOfFile:thumbPath];
    [rowPhotoButton setImage:thumbImage forState:UIControlStateNormal];
    [rowPhotoButton removeTarget:self action:@selector(rowPhotoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *rowImageId = [rowStory objectForKey:@"image_id"];
    
    if ((NSNull *)rowImageId != [NSNull null]) {
        [rowPhotoButton addTarget:self action:@selector(rowPhotoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImage *loadedImage = [loadedImages objectForKey:rowImageId];
        if (loadedImage != nil) {
            [rowPhotoButton setImage:loadedImage forState:UIControlStateNormal];
        } else {
            // We are doing this in a new thread, because we need to wait
            // for a response from the server, and that would take too long
            [NSThread detachNewThreadSelector:@selector(getPhotoForRow:) toTarget:self withObject:[NSNumber numberWithInt:row]];
        }
    }
    
    // Set cell text contents
    [cell setCellHeadline:[rowStory objectForKey:@"headline"]];
    [cell setCellDate:[rowStory objectForKey:@"date"]];
    
    NSString *rowStoryAddress = [rowStory objectForKey:@"address"];
    NSString *rowStoryDistance = [rowStory objectForKey:@"distance"];
    NSString *addressAndDistance = [rowStoryAddress stringByAppendingFormat:@", %@", rowStoryDistance];
    [cell setCellAddressAndDistance:addressAndDistance];
    
    UILabel *latestTextLabel = (UILabel *)[cell viewWithTag:kLatestTextTag];
    latestTextLabel.text = [rowStory objectForKey:@"text"];
    [latestTextLabel alignTop];
    
    cell.tag = row+kCellTagOffset;
    
    NSLog(@"Finished drawing cell");
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableData count];
}

#pragma mark - Table view delegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.headlineField resignFirstResponder];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSInteger row = [indexPath row];
    NSDictionary *rowData = [tableData objectAtIndex:row];
    NSDictionary *storyData = [rowData objectForKey:@"Story"];
    NSString *storyId = [storyData objectForKey:@"id"];
    NSString *storyHeadline = [storyData objectForKey:@"headline"];
    NSString *storyAddress = [storyData objectForKey:@"address"];
    NSString *storyDate = [storyData objectForKey:@"date"];
    NSString *storyDistance = [storyData objectForKey:@"distance"];
 
    HeadlineViewController *storyViewController = [[HeadlineViewController alloc] init];
    storyViewController.storyId = [NSNumber numberWithInt:[storyId intValue]];
    storyViewController.headlineText = storyHeadline;
    storyViewController.addressText = storyAddress;
    storyViewController.dateText = storyDate;
    storyViewController.distanceText = storyDistance;
    
    [self.navigationController pushViewController:storyViewController animated:YES];
    
    [storyViewController drawView];
    [storyViewController release];
}

#pragma mark - Fetching headlines

- (void)fetchHeadlines
{
    waitingForGps = NO;
    
    if(fetchingCurrently) {
        return;
    }
    
    if ([tableData count] == 0) {
        [self showHudWithDescription:@"Loading headlines"];
    }
    
    fetchingCurrently = YES;
    
    NSLog(@"Fetching headlines");
    
    [headlineModel getHeadlines];
}

#pragma mark - Headline delegate methods

- (void)gotHeadlines:(NSObject *)headlines
{    
    NSLog(@"Got headlines");
    fetchingCurrently = NO;
    [HUD hide:YES];
    
    [self.tableData release];
    self.tableData = [[NSMutableArray alloc] initWithArray:(NSArray *)headlines];
    
    [self.titleList reloadData];
}

- (void)gettingHeadlinesFailedWithMessage:(NSString *)message
{
    fetchingCurrently = NO;
    [HUD hide:YES];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Getting headlines failed" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)submittingHeadlineFailedWithMessage:(NSString *)message
{
    [HUD hide:YES];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Headline" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

#pragma mark - Getting and showing thumbnail images

- (void)getPhotoForRow:(NSNumber *)row
{
    // This method should be in it's own thread, so we need AutoreleasePool.
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    // Sleep to make sure that the cell is loaded before showing the photo
    [NSThread sleepForTimeInterval:0.6f];
    
    NSInteger rowStoryPhotoId = [self getImageIdForRow:[row intValue]];
    NSInteger rowStoryId = [self getStoryIdForRow:[row intValue]];
    
    NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
    [info setValue:[NSNumber numberWithInt:rowStoryId] forKey:@"storyId"];
    [info setValue:row forKey:@"row"];
    
    [photoModel getPhotoWithId:rowStoryPhotoId height:58 width:58 cut:YES info:info];
    [info release];
    
    [pool drain];
}

- (void)gotPhoto:(UIImage *)photo withInfo:(NSDictionary *)info
{    
    NSInteger row = [[info objectForKey:@"row"] integerValue];
    NSInteger photoId = [[info objectForKey:@"photoId"] integerValue];
    
    [self showImage:photo inRowWithTag:row+kCellTagOffset];
    
    [loadedImages setValue:photo forKey:[NSString stringWithFormat:@"%d",photoId]];
}

- (void)gettingPhotoFailedWithMessage:(NSString *)message
{
    // Lets just leave the default thumbnail visible, so no need for action
}

- (void)showImage:(UIImage *)image inRowWithTag:(NSInteger)tag
{
    UITableViewCell *cellView = (UITableViewCell *)[self.view viewWithTag:tag];
    UIButton *imageButton = (UIButton *)[cellView viewWithTag:kImageTag];
    [imageButton setImage:image forState:UIControlStateNormal];
}

#pragma mark - UI Actions

- (IBAction)submitHeadline:(id)sender {    
    [self showHudWithDescription:@"Sending headline"];
    
    [headlineModel submitHeadline:self.headlineField.text];
    
    [headlineField setText:@""];
}

- (IBAction)newTextButtonPressed:(id)sender 
{
    [self.headlineField resignFirstResponder];
    
    UIButton *senderButton = (UIButton *)sender;
    
    NSInteger row = [senderButton superview].tag-kCellTagOffset;
    
    NSDictionary *rowData = [tableData objectAtIndex:row];
    NSDictionary *storyData = [rowData objectForKey:@"Story"];
    NSString *storyId = [storyData objectForKey:@"id"];
    NSString *storyHeadline = [storyData objectForKey:@"headline"];
    NSString *storyAddress = [storyData objectForKey:@"address"];
    NSString *storyDate = [storyData objectForKey:@"date"];
    NSString *storyDistance = [storyData objectForKey:@"distance"];
    
    NewTextViewController *newTextViewController = [[NewTextViewController alloc] initWithId:[NSNumber numberWithInt:[storyId integerValue]]];
    
    newTextViewController.headlineText = storyHeadline;
    newTextViewController.addressText = storyAddress;
    newTextViewController.dateText = storyDate;
    newTextViewController.distanceText = storyDistance;
    
    [self.navigationController pushViewController:newTextViewController animated:YES];
    [newTextViewController release];
}
     
- (void)newPhotoButtonPressed:(id)sender
{
    [self.headlineField resignFirstResponder];
    
    UIButton *senderButton = (UIButton *)sender;
    NSNumber *storyId = [NSNumber numberWithInteger:[self getStoryIdForRow:[senderButton superview].tag-kCellTagOffset]];
    if(self.newPhotoController == nil) {
        self.newPhotoController = [[NewPhotoController alloc] init];
    }
    self.newPhotoController.storyId = storyId;
    self.newPhotoController.controller = self.navigationController;

    [newPhotoController takePhoto];
}

- (void)rowPhotoButtonPressed:(id)sender
{
    [self.headlineField resignFirstResponder];
    
    UIButton *senderButton = (UIButton *)sender;
    NSInteger row = [senderButton superview].tag-kCellTagOffset;
    NSNumber *storyId = [NSNumber numberWithInt:[self getStoryIdForRow:row]];
    NSInteger imageId = [self getImageIdForRow:row];
    
    PhotoViewController *photoViewController = [[PhotoViewController alloc] init];
    photoViewController.storyId = storyId;
    photoViewController.imageId = [NSNumber numberWithInt:imageId];
    [self.navigationController pushViewController:photoViewController animated:YES];
    [photoViewController release];
}

#pragma mark - HUD methods

- (void)hudWasHidden {
    [HUD removeFromSuperview];
}

- (void)showHudWithDescription:(NSString *)description
{
    HUD.labelText = description;
    NSLog(@"Label: %@", HUD.labelText);
    if([[self.view subviews] indexOfObject:HUD] == NSNotFound) {
        NSLog(@"Showing HUD");
        [self.view addSubview:HUD];
        [HUD show:YES];
    } else {
        NSLog(@"Updating HUD");
    }
}

#pragma mark - Data helpers

- (NSInteger)getImageIdForRow:(NSInteger)row
{
    NSDictionary *rowData = [self.tableData objectAtIndex:row];
    NSDictionary *rowStory = [rowData objectForKey:@"Story"];
    NSNumber *imageId = [rowStory objectForKey:@"image_id"];
    if ((NSNull *)imageId == [NSNull null]) {
        return 0;
    } else {
        return [imageId integerValue];
    }
}

- (NSInteger)getStoryIdForRow:(NSInteger)row
{
    NSDictionary *rowData = [self.tableData objectAtIndex:row];
    NSDictionary *rowStory = [rowData objectForKey:@"Story"];
    return [[rowStory objectForKey:@"id"] integerValue];
}

#pragma mark - Text Field delegate methods

// Limit headline's maximum length
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > MAX_HEADLINE_LENGTH) ? NO : YES;
}

#pragma mark - Handling GPS fail

// We check every 7 seconds if we have _any_ gps data available (might
// be old or inaccurate etc), and if we have, we should use that. 
// This is done just to make sure that the user gets at least some content
// if they happen to be in a "bad" place, where gps is not available.
- (void)handleGpsFail
{
    NSAutoreleasePool *autoreleasePool = [[NSAutoreleasePool alloc] init];
    [NSThread sleepForTimeInterval:7];
    
    if (waitingForGps && [GPS sharedInstance].latitude != nil) {
        NSLog(@"Failed to get accurate GPS location");
        
        [self fetchHeadlines];
        
        waitingForGps = NO;
    } else {
        [self handleGpsFail];
    }
    
    [autoreleasePool drain];
}

@end