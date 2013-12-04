//
//  AJBDefaultMessageViewController.m
//  FirstImpressions
//
//  Created by Alex Brashear on 11/21/13.
//  Copyright (c) 2013 SamAlexDave. All rights reserved.
//

#import "AJBDefaultMessageViewController.h"
#define sendMessageFailedAlertTag 0

@interface AJBDefaultMessageViewController ()

@property (nonatomic, strong) IBOutlet UITextView *inputMessage;
@property (nonatomic, strong) IBOutlet UILabel *DefaultMessage;
@property (nonatomic, strong) NSArray *messages;
@property (nonatomic, strong) SADParseDataModel *parseManager;

@end

@implementation AJBDefaultMessageViewController {
    int index;
}

- (SADParseDataModel *)parseManager
{
	if (!_parseManager) {
		_parseManager = [[SADParseDataModel alloc] init];
	}
	
	return _parseManager;
}


-(IBAction)getNewDefaultMessage:(id)sender {
    
    if (index >= [_messages count]) {
        index = 0;
    }
    NSInteger i = index;
    _DefaultMessage.text = [_messages objectAtIndex:i];
    index++;
    
    
}

-(IBAction)sendAMessageToParse:(id)sender{
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
        
        NSLog(@"this is the input message : %@", _inputMessage.text);
        NSString *input = [NSString stringWithFormat:@"%@ %@", _DefaultMessage.text, _inputMessage.text];
        BOOL flag = [self.parseManager sendAMessageToParse:input];
        
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


- (void)segueToReceivedMessage {
	//Activate segue
	_inputMessage.text = @"";
	[self performSegueWithIdentifier:@"ReceivedMessageSegue3" sender:self];
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
    // create default array
    NSString *message1 = @"I have a riddle:";
    NSString *message2 = @"Did you know that ";
    NSString *message3 = @"I bet you didn't know this about cats";
    NSString *message4 = @"youre not very creative";
    
    _messages = @[message1, message2, message3, message4];
    
    _DefaultMessage.text = @"Push the button for a default!";
    index = 0;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
