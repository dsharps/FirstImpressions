//
//  SSMLoginViewController.m
//  FirstImpressions
//
//  Created by Samantha Merritt on 11/19/13.
//  Copyright (c) 2013 SamAlexDave. All rights reserved.
//

#import "SSMLoginViewController.h"
#import "SSMHistoryViewController.h"
#import "SSMMessage.h"

@interface SSMLoginViewController () <SSMCommunicationsDelegate>
@property (nonatomic, strong) IBOutlet UIButton *btnLogin;
@end

@implementation SSMLoginViewController
{
    NSMutableArray *_messages;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Outlet for FBLogin button
- (IBAction) loginPressed:(id)sender
{
    // Disable the Login button to prevent multiple touches
    [_btnLogin setEnabled:NO];
    [[PFInstallation currentInstallation] setObject:[PFUser currentUser] forKey:@"user"];
    [[PFInstallation currentInstallation] saveEventually];
    
    // Do the login
    [SSMCommunications login:self];
}

- (void) commsDidLogin:(BOOL)loggedIn {
	// Re-enable the Login button
	[_btnLogin setEnabled:YES];
    
	// Did we login successfully ?
	if (loggedIn) {
        //NSLog([NSString stringWithFormat:@"%@", [PFUser currentUser].username]);
		[self performSegueWithIdentifier:@"LoginSuccessful" sender:self];
	} else {
		// Show error alert
		[[[UIAlertView alloc] initWithTitle:@"Login Failed"
                                    message:@"Facebook Login failed. Please try again"
                                   delegate:nil
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil] show];
	}
}

@end
