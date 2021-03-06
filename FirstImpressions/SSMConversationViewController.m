//
//  SSMConversationViewController.m
//  FirstImpressions
//
//  Created by David Sharples on 11/19/13.
//  Copyright (c) 2013 SamAlexDave. All rights reserved.
//

#import "SSMConversationViewController.h"
#import <Parse/Parse.h>

@interface SSMConversationViewController ()

@end

@implementation SSMConversationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	_messageBody.text = _message[@"body"];
	_messageResponse.text = _message[@"response"];
	
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	
	[formatter setDateStyle:NSDateFormatterLongStyle];
	
	NSString *messageDateString = [formatter stringFromDate:_message.createdAt];
	NSLog(@"Message date string: %@", messageDateString);
	self.title = messageDateString;
	
	UIFont *geared = [UIFont fontWithName:@"GearedSlab-Regular" size:26];
	//_instructionLabel.font = geared;
	_shareContactInfoButton.titleLabel.font = [UIFont fontWithName:@"GearedSlab-Regular" size:26];
	[_shareContactInfoButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, -7, 0)];
	
	//NSNumber trueValue = NSN;
	//NSInteger falseValue = 0;
	PFUser *sendingUser = _message[@"sendingUser"];
	
    if ([[PFUser currentUser].objectId isEqual:sendingUser.objectId]) {
	if (_message[@"handshake"] == [NSNumber numberWithBool:NO]) {
		//handshake was set to false, hide button
		NSLog(@"Handshake set to NO %@", _message[@"handshake"]);
		_shareContactInfoButton.hidden = YES;
	} else if (_message[@"handshake"] == [NSNumber numberWithBool:YES]) {
		NSLog(@"Handshake set to YES %@", _message[@"handshake"]);
		_shareContactInfoButton.hidden = NO;
	} else {
		//handshake not set
		NSLog(@"Handshake not set %@", _message[@"handshake"]);
		_shareContactInfoButton.hidden = YES;
	}
    } else {
		//user is not sending user, cannot view shareContact
		_shareContactInfoButton.hidden = YES;
    }
}

- (IBAction)shareContactInfo
{
	NSLog(@"Clicked button");
	PFUser *respondingUser = _message[@"respondingUser"];
	//PFUser *respondingUser = [PFUser currentUser];
	[respondingUser fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
		NSString *FBURL = [NSString stringWithFormat:@"fb://profile/%@", [respondingUser objectForKey:@"facebookId"]];
		NSString *regularURL = [NSString stringWithFormat:@"http://facebook.com/%@", [respondingUser objectForKey:@"facebookId"]];
		NSLog(@"FB token: %@", FBURL);
		BOOL fbInstalled = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:FBURL]];
		if (fbInstalled) {
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:FBURL]];
		} else {
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:regularURL]];
		}
	}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
