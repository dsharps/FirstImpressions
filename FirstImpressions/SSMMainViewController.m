//
//  SSMMainViewController.m
//  FirstImpressions
//
//  Created by Samantha Merritt on 11/12/13.
//  Copyright (c) 2013 SamAlexDave. All rights reserved.
//

#import "SSMMainViewController.h"
#import <Parse/Parse.h>

@interface SSMMainViewController ()

@property (nonatomic, strong) IBOutlet UITextView *inputMessage;
@property (nonatomic, strong) IBOutlet UILabel *outputMessage;


-(IBAction)sendAMessageToParse:(id)sender;
-(IBAction)retrieveAMessageFromParse:(id)sender;

@end

@implementation SSMMainViewController

-(IBAction)sendAMessageToParse:(id)sender{
	[_inputMessage resignFirstResponder];
    PFQuery *query = [PFQuery queryWithClassName:@"Message"];
    [query whereKey:@"messageName" equalTo:@"Test Message"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error){
            if([objects count] == 0){
            //save message for first time
                PFObject *parseMessage = [PFObject objectWithClassName:@"Message"];
                parseMessage[@"messageName"] = @"Test Message";
                parseMessage[@"body"] = _inputMessage.text;
                [parseMessage saveInBackground];
            } else {
            //update message
                PFObject *messageToUpdate = objects[0];
                messageToUpdate[@"body"] = _inputMessage.text;
                [messageToUpdate saveInBackground];
            }
        } else {
            //error
        }
    }];
}

-(IBAction)retrieveAMessageFromParse:(id)sender{
    PFQuery *query = [PFQuery queryWithClassName:@"Message"];
    [query whereKey:@"messageName" equalTo:@"Test Message"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error){
            if([objects count] == 0){
                //do nothing
            } else {
                //update message
                PFObject *messageToShow = objects[0];
                _outputMessage.text = [NSString stringWithFormat:@"%@",messageToShow[@"body"]];
                
                NSLog([NSString stringWithFormat:@"%@",messageToShow[@"body"]]);
            }
        } else {
            //error
        }
    }];
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
