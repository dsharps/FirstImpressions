//
//  SSMResponseViewController.m
//  FirstImpressions
//
//  Created by David Sharples on 11/19/13.
//  Copyright (c) 2013 SamAlexDave. All rights reserved.
//

#import "SSMResponseViewController.h"

@interface SSMResponseViewController ()

@property (nonatomic, retain) UIToolbar *keyboardToolbar;


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
	[self.parseManager updateMessage:_receivedMessage WithResponse:_inputText.text WithHandshake:_handshake.isOn];
	
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
    [self setupKeyboardToolbar];
    _inputText.inputAccessoryView = self.keyboardToolbar;
	// Do any additional setup after loading the view.
	NSLog([NSString stringWithFormat:@"MM Message Body: %@", self.messageManager.receivedMessage[@"body"]]);

	//load the message text that we set from the previous view
	_receivedMessageLabel.text = self.receivedMessage[@"body"];
}
///////////////////   keyboard toolbar stuff /////////////////////

- (void)setupKeyboardToolbar
{
    if (self.keyboardToolbar == nil) {
        self.keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"done"
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self
                                                                      action:@selector(resignKeyboard:)];
        UIBarButtonItem *extraspace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                    target:self
                                                                                    action:nil];
        [self.keyboardToolbar setItems:[[NSArray alloc] initWithObjects:extraspace, doneButton, nil]];
    }
}
- (void)resignKeyboard:(id)sender
{
    [_inputText resignFirstResponder];
}



//////////////////////////////////////////////////////////////////

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
