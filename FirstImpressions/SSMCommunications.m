//
//  SSMCommunications.m
//  FirstImpressions
//
//  Created by Samantha Merritt on 11/19/13.
//  Copyright (c) 2013 SamAlexDave. All rights reserved.
//

#import "SSMCommunications.h"
#import <Parse/Parse.h>

@implementation SSMCommunications

+ (void) login:(id<SSMCommunicationsDelegate>)delegate
{
	// Basic User information and your friends are part of the standard permissions
	// so there is no reason to ask for additional permissions
	[PFFacebookUtils logInWithPermissions:nil block:^(PFUser *user, NSError *error) {
		// Was login successful ?
		if (!user) {
			if (!error) {
                NSLog(@"The user cancelled the Facebook login.");
            } else {
                NSLog(@"An error occurred: %@", error.localizedDescription);
            }
            
			// Callback - login failed
			if ([delegate respondsToSelector:@selector(commsDidLogin:)]) {
				[delegate commsDidLogin:NO];
			}
		} else {
			if (user.isNew) {
				NSLog(@"User signed up and logged in through Facebook!");
			} else {
				NSLog(@"User logged in through Facebook!");
			}
            
			// Callback - login successful
			if ([delegate respondsToSelector:@selector(commsDidLogin:)]) {
				[delegate commsDidLogin:YES];
			}
		}
	}];
}

@end
