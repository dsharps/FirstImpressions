//
//  SSMReceivedMessageViewController.m
//  FirstImpressions
//
//  Created by David Sharples on 11/19/13.
//  Copyright (c) 2013 SamAlexDave. All rights reserved.
//

#import "SSMReceivedMessageViewController.h"
#import "SSMComposeViewController.h"
#import "SSMResponseViewController.h"
#import "SSMDataManager.h"

@interface SSMReceivedMessageViewController ()

@property (nonatomic, strong) SSMDataManager *messageManager;
@property (nonatomic, strong) SADParseDataModel *parseManager;
@property (nonatomic, strong) IBOutlet UILabel *receivedMessageLabel;
@property (nonatomic, strong) PFObject *receivedMessage;

- (IBAction)rejectMessage:(id)sender;
- (IBAction)respondToMessage:(id)sender;

@end

@implementation SSMReceivedMessageViewController

- (SADParseDataModel *)parseManager
{
	NSLog(@"Setting up _messageManager in Response view");
	if (!_parseManager) {
		_parseManager = [[SADParseDataModel alloc] init];
	}
	
	return _parseManager;
}

- (SSMDataManager *)messageManager
{
	NSLog(@"Retrieving _messageManager");
	if (!_messageManager) {
		_messageManager = [[SSMDataManager alloc] init];
	}
	
	return _messageManager;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
	[self navigationController].navigationBarHidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	//_receivedMessage = [self.parseManager retrieveAMessageFromParseWithBlocking];
	NSLog(@"In RVC, got back _receivedMessage. Body: %@", _message[@"body"]);
	_receivedMessageLabel.text = _message[@"body"];
	
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"geometry"]];
}

- (IBAction)rejectMessage:(id)sender
{
	NSLog(@"Rejected Message");
	//go back to the compose view
	UINavigationController *navController = self.navigationController;
	[navController popViewControllerAnimated:YES];
}

- (IBAction)respondToMessage:(id)sender
{
	NSLog(@"Accepted Message");
	
	//segue to the response view
	[self performSegueWithIdentifier:@"composeResponseSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"composeResponseSegue"]){
		
		//Pushing the data forward in a janky manner
		//TODO fix this (can't use NSUserDefaults - Core Data?)
		
        SSMResponseViewController *controller = (SSMResponseViewController *)segue.destinationViewController;
		controller.receivedMessage = _message;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
