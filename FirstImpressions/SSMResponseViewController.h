//
//  SSMResponseViewController.h
//  FirstImpressions
//
//  Created by David Sharples on 11/19/13.
//  Copyright (c) 2013 SamAlexDave. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SADParseDataModel.h"

@interface SSMResponseViewController : UIViewController

@property (nonatomic, strong) SSMDataManager *messageManager;
@property (nonatomic, strong) IBOutlet UILabel *receivedMessageLabel;
@property (nonatomic, strong) IBOutlet UITextView *inputText;
@property (nonatomic, strong) IBOutlet UISwitch *handshake;
@property (nonatomic, strong) IBOutlet UIButton *sendButton;
@property (nonatomic, strong) PFObject *receivedMessage;
@property (nonatomic, strong) SADParseDataModel *parseManager;

@end
