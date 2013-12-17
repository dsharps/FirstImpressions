//
//  SSMMainViewController.h
//  FirstImpressions
//
//  Created by Samantha Merritt on 11/12/13.
//  Copyright (c) 2013 SamAlexDave. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SADParseDataModel.h"

@interface SSMComposeViewController : UIViewController

@property (nonatomic, strong) SADParseDataModel *parseManager;
@property (nonatomic, strong) IBOutlet UILabel *instructionLabel;
@property (nonatomic, strong) IBOutlet UIButton *sendButton;

@end
