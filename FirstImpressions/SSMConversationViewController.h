//
//  SSMConversationViewController.h
//  FirstImpressions
//
//  Created by David Sharples on 11/19/13.
//  Copyright (c) 2013 SamAlexDave. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSMConversationViewController : UIViewController

@property (nonatomic, strong) PFObject *message;
@property (nonatomic, strong) IBOutlet UITextView *messageBody;
@property (nonatomic, strong) IBOutlet UITextView *messageResponse;
@property (nonatomic, strong) IBOutlet UIButton *shareContactInfoButton;

@end
