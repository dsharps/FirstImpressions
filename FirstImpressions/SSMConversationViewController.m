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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
