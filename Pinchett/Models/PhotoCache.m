//
//  ImageCache.m
//  Proto3
//
//  Created by kkar on 6/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PhotoCache.h"

@implementation PhotoCache

static PhotoCache *sharedInstance;

+ (PhotoCache *)sharedInstance
{
    @synchronized(self) {
        if (!sharedInstance) {
            sharedInstance = [[PhotoCache alloc] init];
        }
    }
    return sharedInstance;
}

+ (id)alloc
{
    @synchronized(self) {
        NSAssert(sharedInstance == nil, @"Attempted to allocate a second instance of singleton ImageCache");
        sharedInstance = [super alloc];
    }
    return sharedInstance;
}

// Get cached image from temporary files
- (UIImage *)getCachedPhoto:(NSString *)filename
{
    NSString *path = [NSTemporaryDirectory() stringByAppendingString:filename];
    if(![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSLog(@"Cache failed to find photo");
        return nil;
    } else {
        NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
        NSLog(@"Cache found photo with size %d", [data length]);
        return [UIImage imageWithData:data];
    }
}

// Store given data in temporary files
- (void)cachePhotoData:(NSData *)photo filename:(NSString *)filename
{
    NSString *path = [NSTemporaryDirectory() stringByAppendingString:filename];
    
    [photo writeToFile:path atomically:YES];
}

@end
