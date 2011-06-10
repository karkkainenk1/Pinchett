//
//  MainViewCell.m
//  Pinchett
//
//  Created by Kimmo Kärkkäinen on 6/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainViewCell.h"

@implementation MainViewCell

@synthesize headline;
@synthesize date;
@synthesize addressAndDistance;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier selected:(BOOL)selected
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        shadowRect = CGRectMake(13, 13, 300, 126);
        shadowColor = [[UIColor colorWithRed:201.0f/255 green:187.0f/255 blue:199.0f/255 alpha:1.0f] retain];
        
        containerRect = CGRectMake(10, 10, 300, 126);
        
        headlineRect = CGRectMake(18, 15, 229, 21);
        headlineColor = [[UIColor blackColor] retain];
        headlineFont = [[UIFont fontWithName:@"Helvetica-Bold" size:18.0f] retain];
        
        dateRect = CGRectMake(19, 36, 225, 15);
        dateColor = [[UIColor lightGrayColor] retain];
        dateFont = [[UIFont fontWithName:@"Helvetica" size:13.0f] retain];
        
        addressAndDistanceRect = CGRectMake(19, 117, 225, 15);
        addressAndDistanceColor = [[UIColor lightGrayColor] retain];
        addressAndDistanceFont = [[UIFont fontWithName:@"Helvetica" size:12.0f] retain];
        
        NSString *separatorPath = [[NSBundle mainBundle] pathForResource:@"separator" ofType:@"png"];
        rowSeparator = [[UIImage imageWithContentsOfFile:separatorPath] retain];
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    return self;
}

- (void)dealloc
{
    [shadowColor release];
    [containerColor release];
    
    [headlineColor release];
    [headlineFont release];
    [headline release];
    
    [dateColor release];
    [dateFont release];
    [date release];
    
    [addressAndDistanceColor release];
    [addressAndDistanceFont release];
    [addressAndDistance release];
        
    [rowSeparator release];
    
    [selectedCell release];
    
    [super dealloc];
}

#pragma mark - Drawing contents

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [containerColor release];
    if (highlighted) {
        containerColor = [[UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1.0f] retain];
    } else {
        containerColor = [[UIColor whiteColor] retain];
    }
    
    [super setHighlighted:highlighted animated:animated];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    NSLog(@"DrawRect");
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Draw row separator
    [rowSeparator drawInRect:CGRectMake(0, 0, 320, 1)];
    
    // Draw background shadow
    CGContextSetFillColorWithColor(context, shadowColor.CGColor);
    CGContextAddRect(context, shadowRect);
    CGContextFillPath(context);
    
    // Draw container
    CGContextSetFillColorWithColor(context, containerColor.CGColor);
    CGContextAddRect(context, containerRect);
    CGContextFillPath(context);
    
    // Draw headline
    CGContextSetFillColorWithColor(context, headlineColor.CGColor);
    [self.headline drawInRect:headlineRect withFont:headlineFont];
    CGContextFillPath(context);
    
    // Draw date
    CGContextSetFillColorWithColor(context, dateColor.CGColor);
    [self.date drawInRect:dateRect withFont:dateFont];
    CGContextFillPath(context);
    
    // Draw address and distance
    CGContextSetFillColorWithColor(context, addressAndDistanceColor.CGColor);
    [self.addressAndDistance drawInRect:addressAndDistanceRect withFont:addressAndDistanceFont];
    CGContextFillPath(context);
    

}

#pragma mark - Setting text variables

- (void)setCellHeadline:(NSString *)newHeadline
{
    [self setHeadline:[newHeadline stringByTruncatingToWidth:headlineRect.size.width withFont:headlineFont]];
    [selectedCell setHeadline:newHeadline];
    [self setNeedsDisplay];
}

- (void)setCellDate:(NSString *)newDate
{
    [self setDate:newDate];
    [selectedCell setHeadline:newDate];
    [self setNeedsDisplay];
}

- (void)setCellAddressAndDistance:(NSString *)newAddressAndDistance
{
    [self setAddressAndDistance:newAddressAndDistance];
    [selectedCell setAddressAndDistance:newAddressAndDistance];
    [self setNeedsDisplay];
}

@end
