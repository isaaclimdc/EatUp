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

    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [NSString stringWithFormat:@"Version %@.%@",
                         [infoDict objectForKey:@"CFBundleShortVersionString"],
                         [infoDict objectForKey:@"CFBundleVersion"]];

    entries = [NSArray arrayWithObjects:@"Home", @"Account", @"Notifications", @"Settings", @"About", @"Logout", version, nil];
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

- (void)scheduleAlarmForDate:(NSDate *)date withMessage:(NSString *)msg
{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *old = [app scheduledLocalNotifications];

    // Clear out the old notification before scheduling a new one.
    if (old.count > 0)
        [app cancelAllLocalNotifications];

    // Create a new notification.
    UILocalNotification *alarm = [[UILocalNotification alloc] init];
    if (alarm) {
        alarm.fireDate = date;
        alarm.timeZone = [NSTimeZone defaultTimeZone];
        alarm.repeatInterval = 0;
        alarm.soundName = @"Glass.aiff";
        alarm.alertBody = msg;

        [app scheduleLocalNotification:alarm];
    }
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

    if (row == entries.count-1) {
        cell.textLabel.font = kEUFontTextItalic;
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else {
        cell.textLabel.font = kEUFontTextBold;
    }

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
        case 2:
            [self showViewController:@"NotificationsNavController"];
            break;
        case 3:
            [self showViewController:@"SettingsNavController"];
            break;
        case 4:
            [self scheduleAlarmForDate:[NSDate dateWithTimeIntervalSinceNow:5] withMessage:@"Invitation to \"Breakfast at Grandma's\" @ 32 Withrow Street"];
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
