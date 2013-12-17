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

- (BOOL)sendAMessageToParse:(NSString*)inputMessage;
- (void)sendAMessageToParse:(NSString *)inputMessage WithBlock:(void (^)(NSInteger))updateProgressBarAndButton;
- (BOOL)saveMessageToCurrentUserRelation:(id)message;
- (void)saveMessageToCurrentUserRelation:(id)message WithBlock:(void (^)(NSInteger))updateProgressBarAndButton;
- (BOOL)saveMessageToQueue:(id)message;
- (void)saveMessageToQueue:(id)message WithBlock:(void (^)(NSInteger))updateProgressBarAndButton;
- (PFObject *)retrieveAMessageFromParse;
- (PFObject *)retrieveAMessageFromParseWithBlocking;
- (void)updateMessage:(PFObject *)message WithResponse:(NSString *)response WithHandshake:(BOOL)response;
- (void)updateMessage:(PFObject *)message WithResponse:(NSString *)response WithHandshake:(BOOL)response WithBlock:(void (^)(NSInteger))updateProgressBarAndButton;
- (void)getAllMessagesForCurrentUserWithBlock:(void (^)(NSArray *))callback;
- (void)getAllMessagesForCurrentUser;

@end
