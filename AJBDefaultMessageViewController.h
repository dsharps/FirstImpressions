//
//  AJBDefaultMessageViewController.h
//  FirstImpressions
//
//  Created by Alex Brashear on 11/21/13.
//  Copyright (c) 2013 SamAlexDave. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SADParseDataModel.h"

@interface AJBDefaultMessageViewController : UIViewController

@property (nonatomic, strong) IBOutlet UILabel *instructionLabel;
@property (nonatomic, strong) IBOutlet UIButton *sendButton;
@property (nonatomic, strong) IBOutlet UIButton *generateButton;

@end
