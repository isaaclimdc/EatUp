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

@synthesize background, spinner;

- (void)viewDidLoad
{
    [super viewDidLoad];
    background = [[UIImageView alloc] initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, self.view.frame.size.height+20)];
    background.image = [UIImage imageNamed:@"Default.png"];
    [self.view insertSubview:background atIndex:0];

    spinner.hidesWhenStopped = YES;
    spinner.hidden = YES;
}

- (IBAction)performLogin:(id)sender
{
    [spinner startAnimating];

    [self performBlock:^{
        [spinner stopAnimating];
    } afterDelay:1];

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

    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kEUUserDefaultsKeyMyEIDs];
    
    [ILAlertView showWithTitle:@"Logged out!"
                       message:@"You have been successfully logged out of EatUp!"
              closeButtonTitle:@"OK"
             secondButtonTitle:nil];
}

@end
