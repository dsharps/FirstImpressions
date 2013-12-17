//
//  SSMReceivedMessageViewController.h
//  FirstImpressions
//
//  Created by David Sharples on 11/19/13.
//  Copyright (c) 2013 SamAlexDave. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSMReceivedMessageViewController : UIViewController

@property (nonatomic, strong) PFObject *message;
@property (nonatomic, strong) IBOutlet UIButton *acceptButton;
@property (nonatomic, strong) IBOutlet UIButton *rejectButton;

@end
