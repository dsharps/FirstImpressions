//
//  SSMDataManager.h
//  FirstImpressions
//
//  Created by David Sharples on 11/19/13.
//  Copyright (c) 2013 SamAlexDave. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSMDataManager : NSObject

@property (nonatomic, strong) PFObject *receivedMessage;
@property (nonatomic, strong) NSString *messageBody;
@property (nonatomic, strong) NSString *testBody;

- (id)initWithPFObject:(PFObject *)message;

@end
