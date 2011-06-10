//
//  ImageCache.h
//  Proto3
//
//  Created by kkar on 6/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@interface PhotoCache : NSObject {
    
}

+ (PhotoCache *)sharedInstance;

- (UIImage *)getCachedPhoto:(NSString *)filename;
- (void)cachePhotoData:(NSData *)photo filename:(NSString *)filename;

@end
