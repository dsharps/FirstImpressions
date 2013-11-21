//
//  SSMResponseViewController.m
//  FirstImpressions
//
//  Created by David Sharples on 11/19/13.
//  Copyright (c) 2013 SamAlexDave. All rights reserved.
//

#import "SSMResponseViewController.h"

@interface SSMResponseViewController ()

@end

@implementation SSMResponseViewController

- (SSMDataManager *)messageManager
{
	NSLog(@"Setting up _messageManager in Response view");
	if (!_messageManager) {
		_messageManager = [[SSMDataManager alloc] init];
	}
	
	return _messageManager;
}

- (IBAction)updateMessageWithResponse:(id)sender
{
	PFObject *messageToUpdate = self.receivedMessage;
	messageToUpdate[@"response"] = _inputText.text;
	messageToUpdate[@"respondingUser"] = [PFUser currentUser];
	[messageToUpdate saveInBackground];
	
	[_inputText resignFirstResponder];
}

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
	// Do any additional setup after loading the view.
	NSLog([NSString stringWithFormat:@"MM Message Body: %@", self.messageManager.receivedMessage[@"body"]]);
	//TODO Make the model work
	//_receivedMessageLabel.text = self.messageManager.receivedMessage[@"body"];
	_receivedMessageLabel.text = self.receivedMessage[@"body"];
}

- (void)viewWillAppear:(BOOL)animated
{
	[self navigationController].navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
