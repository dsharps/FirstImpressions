//
//  SADParseDataModel.h
//  FirstImpressions
//
//  Created by Alex Brashear on 12/3/13.
//  Copyright (c) 2013 SamAlexDave. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SADParseDataModel : NSObject

@property (nonatomic, strong) SSMDataManager *messageManager;

-(BOOL)sendAMessageToParse:(NSString*)inputMessage;
-(BOOL)saveMessageToCurrentUserRelation:(id)message;
-(BOOL)saveMessageToQueue:(id)message;
-(PFObject *)retrieveAMessageFromParse;
-(PFObject *)retrieveAMessageFromParseWithBlocking;
-(void)updateMessage:(PFObject *)message WithResponse:(NSString *)response;

@end
