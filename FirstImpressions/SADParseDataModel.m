//
//  SADParseDataModel.m
//  FirstImpressions
//
//  Created by Alex Brashear on 12/3/13.
//  Copyright (c) 2013 SamAlexDave. All rights reserved.
//

#import "SADParseDataModel.h"

@implementation SADParseDataModel

- (SSMDataManager *)messageManager
{
	NSLog(@"Retrieving _messageManager");
	if (!_messageManager) {
		_messageManager = [[SSMDataManager alloc] init];
	}
	
	return _messageManager;
}

//Upload message to the Giant Pool O' Messages
-(BOOL)sendAMessageToParse:(NSString*)inputMessage{
	//It has to create the message object and add it to both the user's relations and the message queue
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

//Save message to sending user's sentMessages relation
- (BOOL)saveMessageToCurrentUserRelation:(id)message {
	PFUser *user = [PFUser currentUser];
	PFRelation *relation = [user relationforKey:@"sentMessages"];
	[relation addObject:message];
    __block BOOL flag = YES;
	[user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
		if (!error) {
			
			//ALSO save the message to the queue
			flag = [self saveMessageToQueue:message];
			
		} else {
			NSLog(@"Couldn't save relation");
            flag = NO;
		}
	}];
    return flag;
}

//Also save the message to the queue
- (BOOL)saveMessageToQueue:(id)message {
	//Grab the master queue
	PFQuery *query = [PFQuery queryWithClassName:@"MessageQueue"];
	[query whereKey:@"name" equalTo:@"MasterQueue"];
    __block BOOL flag = YES;
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
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

//Asynchronous, but we can't figure out how to return things from the callback block
-(PFObject *)retrieveAMessageFromParse {
	__block PFObject *receivedMessage;
	
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
						//get the oldest message and update label
						NSLog([NSString stringWithFormat:@"Found %d messages", objects.count]);
						receivedMessage = objects[0];
						NSLog(@"Set Received Message - body: %@", receivedMessage[@"body"]);
						
						//remove received message from the queue
						[messagesRelation removeObject: objects[0]];
						[masterQueue saveInBackground];
						
						//also add message to User's received messages relation
						PFUser *user = [PFUser currentUser];
						PFRelation *userRelation = [user relationforKey:@"receivedMessages"];
						[userRelation addObject:objects[0]];
						[user saveInBackground];
					}
				}];
			}
        } else {
            //error
			NSLog(@"Error retrieving from parse");
        }
    }];
	NSLog(@"Returning Received Message - body: %@", receivedMessage[@"body"]);
	return receivedMessage;
}

//Blocks the main thread, but it works
-(PFObject *)retrieveAMessageFromParseWithBlocking {
	PFObject *receivedMessage;
	
    PFQuery *query = [PFQuery queryWithClassName:@"MessageQueue"];
    [query whereKey:@"name" equalTo:@"MasterQueue"];
	
	NSError *__autoreleasing*error = NULL;
	
    NSArray *objects = [query findObjects:error];
	NSLog(@"%@", error);
	if(error){
		//error
		NSLog(@"Error retrieving from parse");
	} else {
		if([objects count] == 0){
			//do nothing
			NSLog(@"Couldn't find the queue");
		} else {
			//Get the master queue, and sort it's messages relation by created, filtering out messages written by current user
			PFObject *masterQueue = (id)objects[0];
			PFRelation *messagesRelation = [masterQueue relationforKey:@"messages"];
			PFQuery *query = [messagesRelation query];
			[query orderByAscending:@"createdAt"];
			[query whereKey:@"sendingUser" notEqualTo:[PFUser currentUser]];
			
			NSError *__autoreleasing*errorForSecondCall = NULL;
			NSArray *foundMessages = [query findObjects:errorForSecondCall];
			
			if (errorForSecondCall) {
				// There was an error
				NSLog(@"Error while retrieving messages in queue: %@", errorForSecondCall);
			} else {
				//Query executed correctly
				if ([foundMessages count] == 0) {
					//but found no messages
					NSLog(@"Watch out! No messages were found...");
				} else {
					//get the oldest message
					NSLog([NSString stringWithFormat:@"Found %d messages", objects.count]);
					receivedMessage = foundMessages[0];
					NSLog(@"Set Received Message - body: %@", receivedMessage[@"body"]);
					
					//remove received message from the queue
					[messagesRelation removeObject: foundMessages[0]];
					[masterQueue saveInBackground];
					
					//also add message to User's received messages relation
					PFUser *user = [PFUser currentUser];
					PFRelation *userRelation = [user relationforKey:@"receivedMessages"];
					[userRelation addObject:foundMessages[0]];
					[user saveInBackground];
				}
			}
		}
	}
	//return message for use
	NSLog(@"Returning Received Message - body: %@", receivedMessage[@"body"]);
	return receivedMessage;
}

- (void)getAllMessagesForCurrentUserWithBlock:(void(^)(NSArray *foundMessages))callback
{
	//query
	PFUser *user = [PFUser currentUser];
	PFRelation *sentRelation = [user relationforKey:@"sentMessages"];
	PFRelation *receivedRelation = [user relationforKey:@"receivedMessages"];
	PFQuery *sentQuery = [sentRelation query];
	PFQuery *receivedQuery = [receivedRelation query];
	
	PFQuery *query = [PFQuery orQueryWithSubqueries:@[sentQuery, receivedQuery]];
	
	[query orderByAscending:@"createdAt"];
	
	[query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
		callback(results);
	}];
}

- (void)updateMessage:(PFObject *)message WithResponse:(NSString *)response WithHandshake:(BOOL)handshake
{
	PFObject *messageToUpdate = message;
	messageToUpdate[@"response"] = response;
	messageToUpdate[@"respondingUser"] = [PFUser currentUser];
    messageToUpdate[@"handshake"] = [NSNumber numberWithBool:handshake];
    
    // Build the actual push notification target query
    PFQuery *query = [PFInstallation query];
    
    // only return Installations that belong to a User that
    // matches the innerQuery
    [query whereKey:@"user" equalTo:message[@"sendingUser"]];
    
    // Send the notification.
    PFPush *push = [[PFPush alloc] init];
    [push setQuery:query];
    [push setMessage:response];
    [push sendPushInBackground];
    
	[messageToUpdate saveInBackground];
	//should we return a bool based on whether or not it succeeds?
}


@end
