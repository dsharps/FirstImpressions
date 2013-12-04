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

- (SADParseDataModel *)parseManager
{
	NSLog(@"Setting up _messageManager in Response view");
	if (!_parseManager) {
		_parseManager = [[SADParseDataModel alloc] init];
	}
	
	return _parseManager;
}

- (IBAction)updateMessageWithResponse:(id)sender
{
	[self.parseManager updateMessage:_receivedMessage WithResponse:_inputText.text];
	
	[_inputText resignFirstResponder];
	
	[self popToComposeView];
}

- (void)popToComposeView
{
	NSLog(@"Returning to Compose view");
	//go back to the compose view
	UINavigationController *navController = self.navigationController;
	int numberOfViews = [[navController viewControllers] count];
	if (numberOfViews > 3) {
		[navController popToViewController:[[navController viewControllers] objectAtIndex:numberOfViews-3] animated:YES];
	}
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

	//load the message text that we set from the previous view
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
