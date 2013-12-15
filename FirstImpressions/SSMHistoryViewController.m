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
#import "SADParseDataModel.h"
#import "SSMConversationViewController.h"

@interface SSMHistoryViewController ()

@property (nonatomic, strong) SADParseDataModel *parseManager;
@property (nonatomic, strong) __block NSArray *messagesArray;
@property (nonatomic) NSInteger messageIndex;

@end

@implementation SSMHistoryViewController

- (SADParseDataModel *)parseManager
{
	NSLog(@"Setting up _messageManager in inbox");
	if (!_parseManager) {
		_parseManager = [[SADParseDataModel alloc] init];
	}
	
	return _parseManager;
}

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

	__block UITableView *inboxTableView = self.tableView;
	NSLog(@"Inbox loaded, getting messages");
	
	void (^inboxCallback)(NSArray *) = ^void(NSArray *foundMessages){
		_messagesArray = foundMessages;
		NSLog(@"Number of messages received in inbox: %d", [foundMessages count]);
		[inboxTableView reloadData];
	};
	
	[self.parseManager getAllMessagesForCurrentUser];
	[self.parseManager getAllMessagesForCurrentUserWithBlock:inboxCallback];
	
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
    return [_messagesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"MessageCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UILabel *messageLabel = (id) [cell viewWithTag:1];
    UILabel *dateLabel = (id) [cell viewWithTag:2];
    UIImage *image = (id) [cell viewWithTag:3];
    
    PFObject *temp = [_messagesArray objectAtIndex:indexPath.row];
    messageLabel.text = temp[@"body"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterLongStyle];
    dateLabel.text = [formatter stringFromDate:temp.createdAt];
    
    if ([PFUser currentUser] == temp[@"sendingUser"]) {
        // sent message image here
        NSLog(@"sent message");
    } else {
        // received message image here
        NSLog(@"received message");
    }
    
    
    /*SSMMessageCell *cell = (SSMMessageCell *)[tableView dequeueReusableCellWithIdentifier:@"MessageCell"];
    
    SSMMessage *message = (self.messages)[indexPath.row];
    cell.senderLabel.text = message.sender;
    cell.bodyLabel.text = message.body;
    
    cell.iconForSender.image = [UIImage imageNamed:@"icon1.jpg"];
    */
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	self.messageIndex = indexPath.row;
    [self performSegueWithIdentifier:@"conversationViewSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"conversationViewSegue"]){
        SSMConversationViewController *controller = (SSMConversationViewController *)segue.destinationViewController;
		controller.message = [_messagesArray objectAtIndex:self.messageIndex];
    }
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
 
 
 PFQuery *query = [PFQuery queryWithClassName:@"User"];
 [query whereKey:@"recievedMessages" equalTo:@"MasterQueue"];
 [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

 */

@end
