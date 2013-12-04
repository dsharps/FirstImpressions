//
//  SADParseDataModel.m
//  FirstImpressions
//
//  Created by Alex Brashear on 12/3/13.
//  Copyright (c) 2013 SamAlexDave. All rights reserved.
//

#import "SADParseDataModel.h"

@implementation SADParseDataModel

-(BOOL)sendAMessageToParse:(NSString*)inputMessage{
		//Create and save the message
		//TODO This is a bit sloppy, but it has to create the message object and add it to both the user's relations and the message queue
		//It shouldn't let you proceed if any of those steps fail.
    
    NSLog(@"Sending message to Parse");
    PFObject *newMessage = [PFObject objectWithClassName:@"Message"];
    newMessage[@"sendingUser"] = [PFUser currentUser];
    newMessage[@"body"] = inputMessage;
    __block BOOL flag = YES;
    [newMessage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            flag = [self saveMessageToCurrentUserRelation:newMessage];
        } else {
            // need to come back and add stuff
            NSLog(@"Couldn't save message");
            flag = NO;
            
        }
    }];
    return flag;
    
}

- (BOOL)saveMessageToCurrentUserRelation:(id)message {
	//Also save message to user's sentMessages relation
	PFUser *user = [PFUser currentUser];
	PFRelation *relation = [user relationforKey:@"sentMessages"];
	[relation addObject:message];
    __block BOOL flag = YES;
	[user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
		if (!error) {
			
			//ALSO save the message to the queue
			flag = [self saveMessageToQueue:message];
			
			//We've saved both the message and the relation
			NSLog(@"Advancing view to received");
			
		} else {
			NSLog(@"Couldn't save relation");
            flag = NO;
		}
	}];
    return flag;
}

- (BOOL)saveMessageToQueue:(id)message {
	PFQuery *query = [PFQuery queryWithClassName:@"MessageQueue"];
	[query whereKey:@"name" equalTo:@"MasterQueue"];
    __block BOOL flag = YES;
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
		//NSLog(@"Launched query");
		if(!error){
			if([objects count] == 0){
				//do nothing
				NSLog(@"Couldn't find the queue");
                flag = NO;
			} else {
				PFObject *masterQueue = (id)objects[0];
				//PFRelation *relation = [masterQueue relationForKey:@"messages"];
				PFRelation *relation = [masterQueue relationforKey:@"messages"];
				[relation addObject:message];
				[masterQueue saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
					if (!error) {
                        flag = YES;
					} else {
						NSLog(@"Couldn't save queue");
                        flag = NO;
					}
				}];
			}
		} else {
			//error
			NSLog(@"Error retrieving queue from parse");
            flag = NO;
		}
	}];
    return flag;
}

-(PFObject*)retrieveAMessageFromParse {
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


@end
