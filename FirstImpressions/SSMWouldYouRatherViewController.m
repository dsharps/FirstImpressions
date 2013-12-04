//
//  SSMWouldYouRatherViewController.m
//  FirstImpressions
//
//  Created by Alex Brashear on 11/24/13.
//  Copyright (c) 2013 SamAlexDave. All rights reserved.
//

#import "SSMWouldYouRatherViewController.h"
#define sendMessageFailedAlertTag 0

@interface SSMWouldYouRatherViewController ()

@property (nonatomic, strong) IBOutlet UITextView *first;
@property (nonatomic, strong) IBOutlet UITextView *second;
@property (nonatomic, strong) SADParseDataModel *parseManager;
@property (nonatomic, retain) UIToolbar *keyboardToolbar;
- (void)previousField:(id)sender;
- (void)nextField:(id)sender;
- (void)setupKeyboardToolbar;
- (void)resignKeyboard:(id)sender;

@end

@implementation SSMWouldYouRatherViewController

- (SADParseDataModel *)parseManager
{
	NSLog(@"Setting up _messageManager in Response view");
	if (!_parseManager) {
		_parseManager = [[SADParseDataModel alloc] init];
	}
	
	return _parseManager;
}

///////////////////////////////////// message sending ////////////////////////////////////////////
-(IBAction)sendAMessageToParse:(id)sender{
	
	//Validate input message
	if ([_first.text  isEqual: @""] || [_second.text  isEqual: @""]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Message"
														message:@"You have to write something in both!"
													   delegate:self
											  cancelButtonTitle:@"Ok"
											  otherButtonTitles:nil, nil];
		[alert show];
	} else {
        
        NSString *inputMessage = [NSString stringWithFormat:@"Would you rather %@ or %@", _first.text, _second.text];
        BOOL flag = [self.parseManager sendAMessageToParse:inputMessage];
        
        if (!flag) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Message"
                                                            message:@"Sending failed"
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:@"Retry", nil];
            alert.tag = sendMessageFailedAlertTag;
            [alert show];
        } else {
            [self segueToReceivedMessage];
        }
		
	}
    
}

-(void)alertView:(UIAlertView*)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView.tag == sendMessageFailedAlertTag) {
        if (buttonIndex == 1) {
            [self sendAMessageToParse:nil];
        }
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////// keyboard toolbar ////////////////////////////////////////

- (void)previousField:(id)sender
{
    if ([_second isFirstResponder]) {
        [_first becomeFirstResponder];
    }
}
- (void)nextField:(id)sender
{
    if ([_first isFirstResponder]) {
        [_second becomeFirstResponder];
    }
}
- (void)setupKeyboardToolbar
{
    if (self.keyboardToolbar == nil) {
        self.keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
        UIBarButtonItem *previousButton = [[UIBarButtonItem alloc] initWithTitle:@"previous"
                                                                           style:UIBarButtonItemStyleBordered
                                                                          target:self
                                                                          action:@selector(previousField:)];
        UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"next"
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self
                                                                      action:@selector(nextField:)];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"done"
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self
                                                                      action:@selector(resignKeyboard:)];
        UIBarButtonItem *extraspace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                    target:self
                                                                                    action:nil];
        [self.keyboardToolbar setItems:[[NSArray alloc] initWithObjects:previousButton, nextButton, extraspace, doneButton, nil]];
    }
}
- (void)resignKeyboard:(id)sender
{
    [_first resignFirstResponder];
    [_second resignFirstResponder];
}




////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////// Segues and defaults /////////////////////////////////////

- (void)segueToReceivedMessage {
	//Activate segue
	_first.text = @"";
    _second.text = @"";
	[self performSegueWithIdentifier:@"ReceivedMessageSegue2" sender:self];
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
	[self navigationController].navigationBarHidden = NO;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setupKeyboardToolbar];
    _first.inputAccessoryView = self.keyboardToolbar;
    _second.inputAccessoryView = self.keyboardToolbar;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
