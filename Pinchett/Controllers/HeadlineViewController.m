//
//  StoryView2Controller.m
//  Proto3
//
//  Created by kkar on 6/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HeadlineViewController.h"

@interface HeadlineViewController (hidden)
- (void)getAndDrawContent;
- (void)clearContents;
- (void)drawContents;
- (void)drawHeader;
- (void)drawImageElement:(NSInteger)row;
- (void)drawTextElement:(NSInteger)row;
- (void)updateScrollViewSize;
- (void)getPhotoWithId:(NSInteger)imageId toElementWithTag:(NSInteger)tag;
- (void)showPhoto:(UIImage *)image inElementWithTag:(NSInteger)tag;
- (void)photoButtonPressed:(id)sender;
- (IBAction)mapButtonPressed:(id)sender;
- (void)drawButtonView;
- (void)newTextButtonPressed:(id)sender;
- (void)newPhotoButtonPressed:(id)sender;
@end


@implementation HeadlineViewController

@synthesize storyId;
@synthesize headlineText;
@synthesize addressText;
@synthesize dateText;
@synthesize distanceText;

- (void)dealloc
{
    [headlineText release];
    [addressText release];
    [dateText release];
    [storyId release];
    [distanceText release];
    HUD.delegate = nil;
    [HUD release];
    [scrollView release];
    [navigationViewController release];
    [contentBlocks release];
    [headlineModel release];
    [photoModel release];
    [self.view release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    if (CFAbsoluteTimeGetCurrent() - lastShown > 900) {
        shouldReloadContent = YES;
    }
    
    if (initialized && shouldReloadContent) {
        currentTextCoordinate = startTextCoordinate;
        currentImageCoordinate = startImageCoordinate;
        
        [self getAndDrawContent];
    }
    
    lastShown = CFAbsoluteTimeGetCurrent();
    shouldReloadContent = YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (id)init
{    
    lastShown = CFAbsoluteTimeGetCurrent();
    
    shouldReloadContent = YES;
    
    initialized = FALSE;
    
    photoModel = [[PhotoModel alloc] init];
    photoModel.delegate = self;
    
    headlineModel = [[HeadlineModel alloc] init];
    headlineModel.delegate = self;
        
    UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    
    // We use our custom navigation, so we need to initialize that
    navigationViewController = [[NavigationViewController alloc] init];
    navigationViewController.controller = self;
    [myView addSubview:navigationViewController.view];
    
    contentBlocks = [[NSMutableArray alloc] init];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 53, 320, 427)];
    scrollView.backgroundColor = [UIColor colorWithRed:236.0f/255 green:228.0f/255 blue:234.0f/255 alpha:1.0f];
    scrollView.alwaysBounceVertical = YES;
    [scrollView setContentSize:CGSizeMake(320, 460)];
    
    [myView addSubview:scrollView];
    
    HUD = [[MBProgressHUD alloc] initWithView:scrollView];
    HUD.delegate = self;
    
    self.view = myView;
        
    return [super init];
}

- (void)drawView
{
    
    [self drawHeader];
    currentTextCoordinate = startTextCoordinate;
    currentImageCoordinate = startImageCoordinate;
    
    [self getAndDrawContent];
    initialized = TRUE;
}
        
#pragma mark - Content loading methods

- (void)getAndDrawContent
{
    NSLog(@"Loading content for story %d",[self.storyId intValue]);
    HUD.labelText = @"Loading content";
    [scrollView addSubview:HUD];
    [HUD show:YES];
    
    [headlineModel getHeadlineWithId:[self.storyId integerValue]];
}

#pragma mark - Headline delegate methods

- (void)gotHeadlines:(NSObject *)headlines
{
    NSLog(@"Got headlines");
    
    [HUD hide:YES];
    
    NSDictionary *headlineDictionary = (NSDictionary *)headlines;
    
    images = [[NSMutableArray alloc] initWithArray:[headlineDictionary objectForKey:@"Image"]];
    texts = [[NSMutableArray alloc] initWithArray:[headlineDictionary objectForKey:@"Text"]];
    
    NSString *latitude = [[headlineDictionary objectForKey:@"Story"] objectForKey:@"latitude"];
    NSString *longitude = [[headlineDictionary objectForKey:@"Story"] objectForKey:@"longitude"];
    
    location = CLLocationCoordinate2DMake([latitude floatValue], [longitude floatValue]);
    
    NSLog(@"Draw contents");
    [self drawContents];
}

- (void)gettingHeadlinesFailedWithMessage:(NSString *)message
{
    [HUD hide:YES];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Getting headlines failed" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

#pragma mark - HUD Delegate methods
- (void)hudWasHidden {
    NSLog(@"HUD was hidden");
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
}

#pragma mark - Drawing content blocks

// Remove all content blocks (except header) so we can replace them
- (void)clearContents
{
    for (UIView *block in contentBlocks) {
        [block removeFromSuperview];
    }
}

- (void)drawContents
{
    [self clearContents];
    
    NSInteger row = 0;
    for (NSDictionary *imageData in images) {
        [self drawImageElement:row];
        row++;
    }
    
    row = 0;
    for (NSDictionary *textData in texts) {
        [self drawTextElement:row];
        row++;
    }
    
    [self updateScrollViewSize];
    
    [self drawButtonView];
}

- (void)drawHeader
{
    NSLog(@"Draw header happened");
    
    CGSize headlineSize = [headlineText sizeWithFont:[UIFont fontWithName:@"Helvetica" size:22] constrainedToSize:CGSizeMake(280, 1000) lineBreakMode:UILineBreakModeWordWrap];
    NSInteger headlineHeight = headlineSize.height;
    NSInteger totalHeight = headlineHeight+45;
    startImageCoordinate = totalHeight+28;
    startTextCoordinate = startImageCoordinate+68;
    
    NSLog(@"Headline height: %d", headlineHeight);
    NSLog(@"Total height: %d", totalHeight);
    NSLog(@"StartImageCoordinate: %d", startImageCoordinate);
    NSLog(@"StartTextCoordinate: %d", startTextCoordinate);
    
    UIView *shadowView = [[UIView alloc] initWithFrame:CGRectMake(13, 11, 300, totalHeight)];
    [shadowView setBackgroundColor:[UIColor colorWithRed:201.0f/255 green:187.0f/255 blue:199.0f/255 alpha:1.0f]];
    [scrollView addSubview:shadowView];
    [shadowView release];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(10, 8, 300, totalHeight)];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *headlineLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 5, 280, headlineHeight)];
    headlineLabel.lineBreakMode = UILineBreakModeWordWrap;
    headlineLabel.numberOfLines = 0;
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
    
    [scrollView addSubview:headerView];
    [headerView release];
    
    UIImageView *separatorView = [[UIImageView alloc] initWithFrame:CGRectMake(0, totalHeight+18, 320, 1)];
    NSString *separatorPath = [[NSBundle mainBundle] pathForResource:@"separator" ofType:@"png"];
    [separatorView setImage:[UIImage imageWithContentsOfFile:separatorPath]];
    [scrollView addSubview:separatorView];
    [separatorView release];
}

- (void)drawButtonView
{
    NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"HeadlineViewButtons" owner:self options:nil];
    if ([nibArray count] > 0) {
        UIView *buttonView = [nibArray objectAtIndex:0];
        
        [buttonView setCenter:CGPointMake(227, startImageCoordinate+31)];
        
        UIButton *newTextButton = (UIButton *)[buttonView viewWithTag:kStoryViewButtonsPenTag];
        [newTextButton addTarget:self action:@selector(newTextButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *newPhotoButton = (UIButton *)[buttonView viewWithTag:kStoryViewButtonsCameraTag];
        [newPhotoButton addTarget:self action:@selector(newPhotoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [scrollView insertSubview:buttonView belowSubview:HUD];
        
        [contentBlocks addObject:buttonView];
    }
}

- (void)drawImageElement:(NSInteger)row
{
    NSString *imageId = [[images objectAtIndex:row] objectForKey:@"id"];
    
    NSInteger rowHeight = 152;
    UIView *imageElementView = [[UIView alloc] initWithFrame:CGRectMake(10, currentImageCoordinate, 120, rowHeight)];
    
    UIView *shadowView = [[UIView alloc] initWithFrame:CGRectMake(13, currentImageCoordinate+3, 120, rowHeight)];
    shadowView.backgroundColor = [UIColor colorWithRed:201.0f/255 green:187.0f/255 blue:199.0f/255 alpha:1.0f];
    [scrollView insertSubview:shadowView belowSubview:HUD];
    [contentBlocks addObject:shadowView];
    [shadowView release];
    
    imageElementView.backgroundColor = [UIColor whiteColor];
    imageElementView.tag = kStoryViewPhotoTagOffset+row;
    
    UIButton *imageButton = [[UIButton alloc] init];
    imageButton.tag = kStoryViewImageTag;
    [imageButton setFrame:CGRectMake(10, 10, 100, 100)];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"default-thumb2" ofType:@"png"];
    UIImage *defaultImage = [UIImage imageWithContentsOfFile:path];
    [imageButton setImage:defaultImage forState:UIControlStateNormal];
    
    [imageButton addTarget:self action:@selector(photoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [imageElementView addSubview:imageButton];
    [imageButton release];
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 119, 100, 12)];
    [dateLabel setFont:[UIFont fontWithName:@"Helvetica" size:12.0f]];
    [dateLabel setTextColor:[UIColor lightGrayColor]];
    dateLabel.text = [[images objectAtIndex:row] objectForKey:@"date"];
    [imageElementView addSubview:dateLabel];
    [dateLabel release];
    
    UILabel *userLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 134, 100, 12)];
    [userLabel setFont:[UIFont fontWithName:@"Helvetica" size:12.0f]];
    [userLabel setTextColor:[UIColor lightGrayColor]];
    userLabel.text = [[images objectAtIndex:row] objectForKey:@"username"];
    [imageElementView addSubview:userLabel];
    [userLabel release];
    
    [scrollView insertSubview:imageElementView belowSubview:HUD];
    [contentBlocks addObject:imageElementView];
    
    [imageElementView release];
    currentImageCoordinate += rowHeight+10;
        
    [self getPhotoWithId:[imageId integerValue] toElementWithTag:kStoryViewPhotoTagOffset+row];
}

- (void)drawTextElement:(NSInteger)row
{
    NSInteger textWidth = 150;
    
    NSString *rowText = [[texts objectAtIndex:row] objectForKey:@"content"];
    CGSize textSize = [rowText sizeWithFont:[UIFont fontWithName:@"Helvetica" size:16.0f] constrainedToSize:CGSizeMake(textWidth, 1000) lineBreakMode:UILineBreakModeWordWrap];
    NSLog(@"Textsize.height: %f", textSize.height);
    NSLog(@"Textsize.width: %f", textSize.width);
    CGSize rowSize = textSize;
    rowSize.height += 46;
    
    UIView *shadowView = [[UIView alloc] initWithFrame:CGRectMake(143, currentTextCoordinate+3, textWidth+20, rowSize.height)];
    shadowView.backgroundColor = [UIColor colorWithRed:201.0f/255 green:187.0f/255 blue:199.0f/255 alpha:1.0f];
    [scrollView insertSubview:shadowView belowSubview:HUD];
    [contentBlocks addObject:shadowView];
    [shadowView release];
    
    UIView *textView = [[UIView alloc] initWithFrame:CGRectMake(140, currentTextCoordinate, textWidth+20, rowSize.height)];
    
    textView.backgroundColor = [UIColor whiteColor];
    textView.tag = kStoryViewTextTagOffset+row;
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, textSize.width, textSize.height)];
    [textLabel setLineBreakMode:UILineBreakModeWordWrap];
    [textLabel setFont:[UIFont fontWithName:@"Helvetica" size:16.0f]];
    textLabel.numberOfLines = 0;
    textLabel.text = rowText;
    [textView addSubview:textLabel];
    [textLabel release];
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, textSize.height+13, textWidth, 14)];
    [dateLabel setFont:[UIFont fontWithName:@"Helvetica" size:12.0f]];
    [dateLabel setTextColor:[UIColor lightGrayColor]];
    dateLabel.text = [[texts objectAtIndex:row] objectForKey:@"date"];
    [textView addSubview:dateLabel];
    [dateLabel release];
    
    UILabel *userLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, textSize.height+28, textWidth, 14)];
    [userLabel setFont:[UIFont fontWithName:@"Helvetica" size:12.0f]];
    [userLabel setTextColor:[UIColor lightGrayColor]];
    userLabel.text = [[texts objectAtIndex:row] objectForKey:@"username"];
    [textView addSubview:userLabel];
    [userLabel release];
    
    [scrollView insertSubview:textView belowSubview:HUD];
    [contentBlocks addObject:textView];
    
    [textView release];
    currentTextCoordinate += rowSize.height+10;
}

- (void)updateScrollViewSize
{
    NSInteger height = 0;
    if (currentTextCoordinate > currentImageCoordinate) {
        height = currentTextCoordinate;
    } else {
        height = currentImageCoordinate;
    }
    [scrollView setContentSize:CGSizeMake(320, height+20)];
}

#pragma mark - Handling photos

- (void)getPhotoWithId:(NSInteger)imageId toElementWithTag:(NSInteger)tag
{
    NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
    [info setValue:[NSNumber numberWithInt:tag] forKey:@"elementTag"];
    
    [photoModel getPhotoWithId:imageId height:100 width:100 cut:YES info:info];
    
    [info release];
}

- (void)showPhoto:(UIImage *)image inElementWithTag:(NSInteger)tag
{
    NSLog(@"Showing image in element %d", tag);
    UIButton *imageButton = (UIButton *)[(UIView *)[self.view viewWithTag:tag] viewWithTag:kStoryViewImageTag];
    [imageButton setImage:image forState:UIControlStateNormal];
}

#pragma mark - Photo delegate methods

- (void)gotPhoto:(UIImage *)photo withInfo:(NSDictionary *)info
{
    NSString *elementTag = [info objectForKey:@"elementTag"];
    if(elementTag != nil) {
        NSInteger tag = [[info objectForKey:@"elementTag"] integerValue];
        
        [self showPhoto:photo inElementWithTag:tag];
    }
}

- (void)gettingPhotoFailedWithMessage:(NSString *)message
{
    // Let's just leave empty box visible if getting photo fails.
}

#pragma mark - Button actions

- (void)photoButtonPressed:(id)sender
{
    shouldReloadContent = NO;
    
    UIButton *senderButton = (UIButton *)sender;
    NSInteger row = [senderButton superview].tag-kStoryViewPhotoTagOffset;
    
    PhotoViewController *photoViewController = [[PhotoViewController alloc] init];
    photoViewController.storyId = storyId;
    NSString *imageId = [[images objectAtIndex:row] objectForKey:@"id"];
    photoViewController.imageId = [NSNumber numberWithInt:[imageId integerValue]];
    
    [self.navigationController pushViewController:photoViewController animated:YES];
    [photoViewController release];
}

- (IBAction)mapButtonPressed:(id)sender {
    shouldReloadContent = NO;
    
    MapViewController *mapViewController = [[MapViewController alloc] initWithLocation:location];
    mapViewController.headline = headlineText;
    
    [self.navigationController pushViewController:mapViewController animated:YES];
    
    [mapViewController release];
}

- (void)newTextButtonPressed:(id)sender 
{
    NewTextViewController *newTextViewController = [[NewTextViewController alloc] initWithId:[NSNumber numberWithInt:[storyId integerValue]]];
    
    newTextViewController.headlineText = headlineText;
    newTextViewController.addressText = addressText;
    newTextViewController.dateText = dateText;
    newTextViewController.distanceText = distanceText;
    
    [self.navigationController pushViewController:newTextViewController animated:YES];
    [newTextViewController release];
}

- (void)newPhotoButtonPressed:(id)sender
{
    NewPhotoController *newPhotoController = [[NewPhotoController alloc] init];
    
    newPhotoController.storyId = storyId;
    newPhotoController.controller = self.navigationController;
    
    [newPhotoController takePhoto];
    
    [newPhotoController release];
}

@end
