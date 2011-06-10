//
//  MainViewCell.h
//  Pinchett
//
//  Created by Kimmo Kärkkäinen on 6/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+TruncateToWidth.h"

@interface MainViewCell : UITableViewCell {
    CGRect shadowRect;
    UIColor *shadowColor;
    
    CGRect containerRect;
    UIColor *containerColor;
    
    NSString *headline;
    CGRect headlineRect;
    UIColor *headlineColor;
    UIFont *headlineFont;
    
    NSString *date;
    CGRect dateRect;
    UIColor *dateColor;
    UIFont *dateFont;
        
    NSString *addressAndDistance;
    CGRect addressAndDistanceRect;
    UIColor *addressAndDistanceColor;
    UIFont *addressAndDistanceFont;
    
    UIImage *rowSeparator;
    
    MainViewCell *selectedCell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier selected:(BOOL)selected;
- (void)setCellHeadline:(NSString *)newHeadline;
- (void)setCellDate:(NSString *)newDate;
- (void)setCellAddressAndDistance:(NSString *)newAddressAndDistance;


@property (retain) NSString *headline;
@property (retain) NSString *date;
@property (retain) NSString *addressAndDistance;

@end
