//
//  LoginViewController.m
//  EatUp
//
//  Created by Isaac Lim on 3/2/13.
//  Copyright (c) 2013 isaacl.net. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize spinner;

- (void)viewDidLoad
{
    [super viewDidLoad];

    spinner.hidesWhenStopped = YES;
    spinner.hidden = YES;
}

- (IBAction)performLogin:(id)sender
{
    [spinner startAnimating];

    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate openSession];
}

- (void)loginFailed
{
    // User switched back to the app without authorizing. Stay here, but stop the spinner.
    [spinner stopAnimating];
}

+ (void)performLogout {
    [FBSession.activeSession closeAndClearTokenInformation];
    
    [ILAlertView showWithTitle:@"Logged out!"
                       message:@"You have been successfully logged out of EatUp!"
              closeButtonTitle:@"OK"
             secondButtonTitle:nil];
}

@end
