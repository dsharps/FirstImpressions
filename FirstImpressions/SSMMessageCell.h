//
//  MessageCell.h
//  FirstImpressions
//
//  Created by Samantha Merritt on 11/18/13.
//  Copyright (c) 2013 SamAlexDave. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSMMessageCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *senderLabel;
@property (nonatomic, weak) IBOutlet UILabel *bodyLabel;
@property (nonatomic, weak) IBOutlet UIImageView *iconForSender;

@end
