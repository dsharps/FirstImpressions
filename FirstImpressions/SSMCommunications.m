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
				// After logging in with Facebook
                [[PFInstallation currentInstallation] setObject:[PFUser currentUser] forKey:@"user"];
				[FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
					if (!error) {
						NSString *facebookId = [result objectForKey:@"id"];
						[user setObject:facebookId forKey:@"facebookId"];
						[user saveInBackground];
					}
				}];
                [[PFInstallation currentInstallation] saveEventually];
			} else {
				NSLog(@"User logged in through Facebook!");
				[FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
					if (!error) {
						NSString *facebookId = [result objectForKey:@"id"];
						NSLog(@"Facebook id: %@", facebookId);
						[user setObject:facebookId forKey:@"facebookId"];
						[user saveInBackground];
					}
				}];
			}
            
			// Callback - login successful
			if ([delegate respondsToSelector:@selector(commsDidLogin:)]) {
				[delegate commsDidLogin:YES];
			}
		}
	}];
}

@end
