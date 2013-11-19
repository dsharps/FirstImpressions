//
//  SSMCommunications.h
//  FirstImpressions
//
//  Created by Samantha Merritt on 11/19/13.
//  Copyright (c) 2013 SamAlexDave. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SSMCommunicationsDelegate <NSObject>
@optional
- (void) commsDidLogin:(BOOL)loggedIn;
@end

@interface SSMCommunications : NSObject
+ (void) login:(id<SSMCommunicationsDelegate>)delegate;
@end
