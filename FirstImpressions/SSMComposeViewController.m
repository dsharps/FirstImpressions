//
//  SSMMainViewController.m
//  FirstImpressions
//
//  Created by Samantha Merritt on 11/12/13.
//  Copyright (c) 2013 SamAlexDave. All rights reserved.
//

#import "SSMComposeViewController.h"
#import "SSMReceivedMessageViewController.h"
#define sendMessageFailedAlertTag 0

@interface SSMComposeViewController ()

@property (nonatomic, strong) IBOutlet UITextView *inputMessage;
@property (nonatomic, retain) UIToolbar *keyboardToolbar;
@property (nonatomic, strong) PFObject *receivedMessage;


- (IBAction)sendAMessageToParse:(id)sender;
- (void)saveMessageToCurrentUserRelation:(id)message;
- (void)saveMessageToQueue:(id)message;
- (void)setupKeyboardToolbar;
- (void)resignKeyboard:(id)sender;

@end

@implementation SSMComposeViewController

- (SADParseDataModel *)parseManager
{
	NSLog(@"Setting up _messageManager in Response view");
	if (!_parseManager) {
		_parseManager = [[SADParseDataModel alloc] init];
	}
	
	return _parseManager;
}

- (IBAction)sendAMessageToParse:(id)sender{
	[_inputMessage resignFirstResponder];
	
	//Validate input message
	if ([_inputMessage.text  isEqual: @""]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Message"
														message:@"You have to write something!"
													   delegate:self
											  cancelButtonTitle:@"Ok"
											  otherButtonTitles:nil, nil];
		[alert show];
	} else {
		
		SSMComposeViewController *controller = self;
		__block UIProgressView *progressView = (UIProgressView *)[controller.view viewWithTag:1];
		
		__block UIButton *sendButton = (UIButton *)[controller.view viewWithTag:2];
		
		void (^updateProgressBarAndButton)(NSInteger) = ^void(NSInteger currentStage) {
			if (currentStage == 1) {
				[progressView setProgress:0.25 animated:YES];
				progressView.hidden = NO;
				[sendButton setTitle:@"SENDING" forState:UIControlStateNormal];
			} else if (currentStage == 2) {
				[progressView setProgress:0.5 animated:YES];
			} else if (currentStage == 3) {
				[progressView setProgress:0.75 animated:YES];
			} else if (currentStage == 4) {
				[progressView setProgress:1 animated:YES];
				progressView.hidden = YES;
				[sendButton setTitle:@"SEND" forState:UIControlStateNormal];
				[self segueToReceivedMessage];
			}
		};
        
        NSLog(@"we are at beginning");
        //BOOL flag = [self.parseManager sendAMessageToParse:_inputMessage.text];
        [self.parseManager sendAMessageToParse:_inputMessage.text WithBlock:updateProgressBarAndButton];
		
		NSLog(@"we are at beginning of conditional");

//        if (!flag) {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Message"
//                                                            message:@"Sending failed"
//                                                           delegate:self
//                                                  cancelButtonTitle:@"Ok"
//                                                  otherButtonTitles:@"Retry", nil];
//            alert.tag = sendMessageFailedAlertTag;
//            [alert show];
//        } else {
//            [self segueToReceivedMessage];
//        }
		
	}

}

- (void)alertView:(UIAlertView*)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView.tag == sendMessageFailedAlertTag) {
        if (buttonIndex == 1) {
            [self sendAMessageToParse:_inputMessage.text];
        }
    }
}




///////////////////   keyboard toolbar stuff /////////////////////

- (void)setupKeyboardToolbar
{
    if (self.keyboardToolbar == nil) {
        self.keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
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
    [_inputMessage resignFirstResponder];
}



//////////////////////////////////////////////////////////////////

- (void)segueToReceivedMessage {
	//Activate segue
	_inputMessage.text = @"";
	_receivedMessage = [self.parseManager retrieveAMessageFromParseWithBlocking];
	if (_receivedMessage == (id)[NSNull null]) {
		NSLog(@"body: %@", _receivedMessage[@"body"]);		[self performSegueWithIdentifier:@"receivedMessageSegue" sender:self];
	} else {
		NSLog(@"Found no messages, not segue-ing");
	}
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if([segue.identifier isEqualToString:@"receivedMessageSegue"]){
		SSMReceivedMessageViewController *controller = [segue destinationViewController];
		NSLog(@"Attaching received message to controller: %@", _receivedMessage[@"body"]);
		controller.message = _receivedMessage;
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

- (void)viewWillAppear:(BOOL)animated
{
	[self navigationController].navigationBarHidden = NO;
	//[self.tabBarController setTitle:@"Blank Message"];
	//[super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setupKeyboardToolbar];
    _inputMessage.inputAccessoryView = self.keyboardToolbar;
	
	for (NSString *family in [UIFont familyNames]) {
		NSLog(@"%@", family);
		for (NSString *name in [UIFont fontNamesForFamilyName:family]){
			NSLog(@"  %@", name);
		}
	}
	
	UIFont *geared = [UIFont fontWithName:@"GearedSlab-Regular" size:26];
	//_instructionLabel.font = geared;
	_sendButton.titleLabel.font = [UIFont fontWithName:@"GearedSlab-Regular" size:26];
	[_sendButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, -7, 0)];
	//self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"creamPixels"]];
	
	[self.view viewWithTag:1].hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
