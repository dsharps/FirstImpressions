//
//  SSMMainViewController.m
//  FirstImpressions
//
//  Created by Samantha Merritt on 11/12/13.
//  Copyright (c) 2013 SamAlexDave. All rights reserved.
//

#import "SSMComposeViewController.h"

@interface SSMComposeViewController ()

@property (nonatomic, strong) IBOutlet UITextView *inputMessage;
@property (nonatomic, strong) IBOutlet UILabel *outputMessage;


-(IBAction)sendAMessageToParse:(id)sender;
- (void)saveMessageToCurrentUserRelation:(id)message;
- (void)saveMessageToQueue:(id)message;

@end

@implementation SSMComposeViewController

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
		//Create and save the message
		//TODO This is a bit sloppy, but it has to create the message object and add it to both the user's relations and the message queue
		//It shouldn't let you proceed if any of those steps fail.
		
		NSLog(@"Sending message to Parse");
		PFObject *newMessage = [PFObject objectWithClassName:@"Message"];
		newMessage[@"sendingUser"] = [PFUser currentUser];
		newMessage[@"body"] = _inputMessage.text;
		[newMessage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
			if (!error) {
				[self saveMessageToCurrentUserRelation:newMessage];
			} else {
				NSLog(@"Couldn't save message");
			}
		}];
	}

}

- (void)saveMessageToCurrentUserRelation:(id)message {
	//Also save message to user's sentMessages relation
	PFUser *user = [PFUser currentUser];
	PFRelation *relation = [user relationforKey:@"sentMessages"];
	[relation addObject:message];
	[user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
		if (!error) {
			
			//ALSO save the message to the queue
			[self saveMessageToQueue:message];
			
			//We've saved both the message and the relation
			NSLog(@"Advancing view to received");
			
		} else {
			NSLog(@"Couldn't save relation");
		}
	}];
}

- (void)saveMessageToQueue:(id)message {
	PFQuery *query = [PFQuery queryWithClassName:@"MessageQueue"];
	[query whereKey:@"name" equalTo:@"MasterQueue"];
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
		//NSLog(@"Launched query");
		if(!error){
			if([objects count] == 0){
				//do nothing
				NSLog(@"Couldn't find the queue");
			} else {
				PFObject *masterQueue = (id)objects[0];
				//PFRelation *relation = [masterQueue relationForKey:@"messages"];
				PFRelation *relation = [masterQueue relationforKey:@"messages"];
				[relation addObject:message];
				[masterQueue saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
					if (!error) {
						[self segueToReceivedMessage];
					} else {
						NSLog(@"Couldn't save queue");
					}
				}];
			}
		} else {
			//error
			NSLog(@"Error retrieving queue from parse");
		}
	}];
}

- (void)segueToReceivedMessage {
	//Activate segue
	_inputMessage.text = @"";
	[self performSegueWithIdentifier:@"ReceivedMessageSegue" sender:self];
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
