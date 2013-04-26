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

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"debut.png"]];

    entries = @[@"Me",
                @"                     ~",
                @"Home",
                @"About",
                @"Logout"];
}

- (IBAction)showLogoutConfirmation {
    ILAlertView *alert = [ILAlertView showWithTitle:@"Logout?"
                                            message:@"This logs your Facebook account out of the EatUp! service."
                                   closeButtonTitle:@"No"
                                  secondButtonTitle:@"Yes"];
    alert.delegate = self;
}

//- (void)scheduleAlarmForDate:(NSDate *)date withMessage:(NSString *)msg
//{
//    UIApplication *app = [UIApplication sharedApplication];
//    NSArray *old = [app scheduledLocalNotifications];
//
//    // Clear out the old notification before scheduling a new one.
//    if (old.count > 0)
//        [app cancelAllLocalNotifications];
//
//    // Create a new notification.
//    UILocalNotification *alarm = [[UILocalNotification alloc] init];
//    if (alarm) {
//        alarm.fireDate = date;
//        alarm.timeZone = [NSTimeZone defaultTimeZone];
//        alarm.repeatInterval = 0;
//        alarm.soundName = @"Glass.aiff";
//        alarm.alertBody = msg;
//
//        [app scheduleLocalNotification:alarm];
//    }
//}

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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        return 30;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SideCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    // Configure the cell...
    NSUInteger row = indexPath.row;
    cell.textLabel.text = [entries objectAtIndex:row];

    if (row == 0 || row == 1 || row == entries.count-1) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (row == 0) {
        NSString *myName = [[NSUserDefaults standardUserDefaults] objectForKey:kEUUserDefaultsKeyMyName];
        NSURL *myImgURL = kEUFBUserProfPic([[NSUserDefaults standardUserDefaults] objectForKey:kEUUserDefaultsKeyMyUID]);
        cell.textLabel.text = [@"             " stringByAppendingString:myName];

        UIImageView *picView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.height, cell.frame.size.height)];
        picView.contentMode = UIViewContentModeScaleAspectFill;
        picView.clipsToBounds = YES;
        [cell addSubview:picView];
        [picView setImageWithURL:myImgURL placeholderImage:[UIImage imageNamed:@"manPlaceholder.png"]];

        CALayer *imageLayer = picView.layer;
        imageLayer.cornerRadius = 5;
        imageLayer.borderWidth = 1;
        imageLayer.borderColor = [UIColor lightGrayColor].CGColor;
        imageLayer.masksToBounds = YES;
        
        cell.textLabel.font = kEUFontTextItalic;
    }
    else if (row == 1) {
        cell.textLabel.font = kEUFontTextItalic;
        cell.textLabel.textColor = [UIColor lightGrayColor];
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
        case 2: {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
            UINavigationController *NC = [storyboard instantiateViewControllerWithIdentifier:@"EventsNavController"];
            EventsViewController *VC = (EventsViewController *)NC.topViewController;
            VC.launchedFromSideMenu = YES;
            [self.revealController setFrontViewController:NC focusAfterChange:YES completion:nil];
            break;
        }
        case 3: {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
            UIViewController *VC = [storyboard instantiateViewControllerWithIdentifier:@"AboutNavController"];
            [self.revealController setFrontViewController:VC focusAfterChange:YES completion:nil];
            break;
        }
        case 4:
            [self showLogoutConfirmation];
            break;
        default:
            break;
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
