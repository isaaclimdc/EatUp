//
//  SideViewController.m
//  EatUp
//
//  Created by Isaac Lim on 3/2/13.
//  Copyright (c) 2013 isaacl.net. All rights reserved.
//

#import "SideViewController.h"

@interface SideViewController () {
    NSArray *entries;
}

@end

@implementation SideViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    entries = [NSArray arrayWithObjects:@"Home", @"Account", @"Notifications", @"Settings", @"About", @"Logout", nil];
}

- (IBAction)showViewController:(NSString *)VCId
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UIViewController *VC = [storyboard instantiateViewControllerWithIdentifier:VCId];
    [self.revealController setFrontViewController:VC focusAfterChange:YES completion:nil];
}

- (IBAction)showLogoutConfirmation {
    ILAlertView *alert = [ILAlertView showWithTitle:@"Logout?"
                                            message:@"This logs your Facebook account out of the EatUp! service."
                                   closeButtonTitle:@"No"
                                  secondButtonTitle:@"Yes"];
    alert.delegate = self;
}

#pragma mark - ILAlertViewDelegate Methods

- (void)alertView:(ILAlertView *)alertView tappedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        /* Do nothing */
        [self.revealController showViewController:self.revealController.frontViewController];
    }
    else if (buttonIndex == 1) {
        /* Do what you want when tapping the second button here */
        [LoginViewController performLogout];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return entries.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SideCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    // Configure the cell...
    NSUInteger row = indexPath.row;
    cell.textLabel.text = [entries objectAtIndex:row];
    cell.textLabel.font = kEUFontTextBold;

    UIView *bgColorView = [[UIView alloc] init];
    [bgColorView setBackgroundColor:kEUMainColor];
    [cell setSelectedBackgroundView:bgColorView];

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = indexPath.row;
    switch (row) {
        case 0:
            [self showViewController:@"EventsNavController"];
            break;
        case 3:
            [self showViewController:@"SettingsNavController"];
            break;
        case 5:
            [self showLogoutConfirmation];
            break;
        default:
            break;
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
