//
//  SSMDataManager.m
//  FirstImpressions
//
//  Created by David Sharples on 11/19/13.
//  Copyright (c) 2013 SamAlexDave. All rights reserved.
//

#import "SSMDataManager.h"

@implementation SSMDataManager

- (NSString *)testBody
{
	return @"THIS IS A TEST";
}

//designated initializers, if needed
- (id)initWithPFObject:(PFObject *)message
{
	self = [super init];
	
	if (message == nil) {
		NSLog(@"Passed Null Data");
	} else {
		self.receivedMessage = message;
	}
	
	return self;
}

- (PFObject *)receivedMessage
{
	//overriding getter
	return [[NSUserDefaults standardUserDefaults] objectForKey:@"receivedMessage"];
}

- (void)setReceivedMessage:(PFObject *)receivedMessage
{
	//overriding setter
	NSLog(@"Saved");
	[[NSUserDefaults standardUserDefaults] setObject:receivedMessage forKey:@"receivedMessage"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

@end
