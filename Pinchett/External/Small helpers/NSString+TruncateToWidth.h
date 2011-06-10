//
//  NSString+TruncateToWidth.h
//  Proto3
//
//  Created by Kimmo Kärkkäinen on 7/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

@interface NSString (TruncateToWidth)

- (NSString*)stringByTruncatingToWidth:(CGFloat)width withFont:(UIFont *)font;

@end
