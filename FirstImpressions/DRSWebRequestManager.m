//
//  DRSWebRequestManager.m
//  FBGraphDemo
//
//  Created by David Sharples on 10/14/13.
//  Copyright (c) 2013 David Sharples. All rights reserved.
//

#import "DRSWebRequestManager.h"
#import "Reachability.h"

@implementation DRSWebRequestManager

+ (BOOL)doesHaveInternetConnection
{
	//check for network access using Apple Reachability
	Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
	
	NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
	
	return (networkStatus == NotReachable) ? NO : YES;
}

+ (NSData *)dataFromURL:(NSURL *)url
{
	//check to see if we have internet
	if (![DRSWebRequestManager doesHaveInternetConnection]) {
		return nil;
	}
	
	
	
	
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
	
	NSURLResponse *urlResponse; //blank objects to hold stuff just in case
	NSError *urlError;
	NSData *urlData = [NSURLConnection sendSynchronousRequest:urlRequest
											returningResponse:&urlResponse
														error:&urlError];
	return urlData;
}

+ (NSData *)dataFromString:(NSString *)urlString
{
	return [DRSWebRequestManager dataFromURL:[NSURL URLWithString:urlString]];
}

@end
