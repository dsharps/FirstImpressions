//
//  SSMMessagesViewController.m
//  FirstImpressions
//
//  Created by Samantha Merritt on 11/18/13.
//  Copyright (c) 2013 SamAlexDave. All rights reserved.
//

#import "SSMHistoryViewController.h"
#import "SSMMessage.h"
#import "SSMMessageCell.h"

@interface SSMHistoryViewController ()

@end

@implementation SSMHistoryViewController

- (IBAction)segueToComposeView:(id)sender
{
	NSLog(@"Advancing view");
	//Activate segue
	[self performSegueWithIdentifier:@"composeNewMessageSegue" sender:self];

}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Seque to the Image Wall
    _messages = [NSMutableArray arrayWithCapacity:20];
    
    SSMMessage *message = [[SSMMessage alloc] init];
    message.body = @"This is the entire content of my message";
    message.sender = @"Unhappy Owl";
    [_messages addObject:message];
    
    message = [[SSMMessage alloc] init];
    message.body = @"Would you rather meet Harry Potter or Ron Weasley?";
    message.sender = @"Unhappy Penguin";
    [_messages addObject:message];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SSMMessageCell *cell = (SSMMessageCell *)[tableView dequeueReusableCellWithIdentifier:@"MessageCell"];
    
    SSMMessage *message = (self.messages)[indexPath.row];
    cell.senderLabel.text = message.sender;
    cell.bodyLabel.text = message.body;
    
    cell.iconForSender.image = [UIImage imageNamed:@"icon1.jpg"];
    
    return cell;
}

- (UIImage *)imageForSender
{
/*    switch (rating) {
        case 1: return [UIImage imageNamed:@"1StarSmall"];
        case 2: return [UIImage imageNamed:@"2StarsSmall"];
        case 3: return [UIImage imageNamed:@"3StarsSmall"];
        case 4: return [UIImage imageNamed:@"4StarsSmall"];
        case 5: return [UIImage imageNamed:@"5StarsSmall"];
    }
 */
    return [UIImage imageNamed:@"icon1.jpg"];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
