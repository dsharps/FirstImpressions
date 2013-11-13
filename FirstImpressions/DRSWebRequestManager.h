//
//  DRSWebRequestManager.h
//  FBGraphDemo
//
//  Created by David Sharples on 10/14/13.
//  Copyright (c) 2013 David Sharples. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DRSWebRequestManager : NSObject

+ (BOOL)doesHaveInternetConnection;
+ (NSData *)dataFromURL:(NSURL *)url;
+ (NSData *)dataFromString:(NSString *)urlString;

@end
