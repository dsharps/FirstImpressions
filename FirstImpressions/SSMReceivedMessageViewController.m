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
@property (nonatomic, strong) IBOutlet UILabel *receivedMessageLabel;

- (IBAction)rejectMessage:(id)sender;
- (IBAction)respondToMessage:(id)sender;

@end

@implementation SSMReceivedMessageViewController

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
	//NSLog([NSString stringWithFormat:@"%@", @"View loaded, starting retrieval"]);
	[self retrieveAMessageFromParse];
	NSLog([self messageManager].testBody);
	//NSLog([NSString stringWithFormat:@"TEST BODY: %@", [self messageManager].testBody]);
	// Do any additional setup after loading the view.
}

-(void)retrieveAMessageFromParse {
    PFQuery *query = [PFQuery queryWithClassName:@"MessageQueue"];
    [query whereKey:@"name" equalTo:@"MasterQueue"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error){
            if([objects count] == 0){
                //do nothing
				NSLog(@"Couldn't find the queue");
            } else {
				PFObject *masterQueue = (id)objects[0];
				PFRelation *messagesRelation = [masterQueue relationforKey:@"messages"];
				PFQuery *query = [messagesRelation query];
				[query orderByAscending:@"createdAt"];
				[query whereKey:@"sendingUser" notEqualTo:[PFUser currentUser]];
				[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
					if (error) {
						// There was an error
						NSLog(@"Error while retrieving messages in queue");
					} else {
						//TODO make the model work
						
						//get the oldest message and update label
						NSLog([NSString stringWithFormat:@"Found %d messages", objects.count]);
						//NSLog(objects[0][@"body"]);
						//NSLog([NSString stringWithFormat:@"Message body: %@", _messageManager.testBody]);
						
						_messageManager.messageBody = objects[0][@"body"];
						_messageManager.receivedMessage = objects[0];
						
						_receivedMessageLabel.text = [NSString stringWithFormat:@"%@", _messageManager.receivedMessage[@"body"]];
						
						//remove received message from the queue
						[messagesRelation removeObject: _messageManager.receivedMessage];
						[masterQueue saveInBackground];
						
						//also add message to User's received messages relation
						PFUser *user = [PFUser currentUser];
						PFRelation *userRelation = [user relationforKey:@"receivedMessages"];
						[userRelation addObject:_messageManager.receivedMessage];
						[user saveInBackground];
					}
				}];
			}
        } else {
            //error
			NSLog(@"Error retrieving from parse");
        }
    }];
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
		//TODO fix this
		
        SSMResponseViewController *controller = (SSMResponseViewController *)segue.destinationViewController;
		controller.receivedMessage = [self messageManager].receivedMessage;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
