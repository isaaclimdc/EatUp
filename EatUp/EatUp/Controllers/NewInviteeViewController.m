//
//  NewInviteeViewController.m
//  EatUp
//
//  Created by Isaac Lim on 4/1/13.
//  Copyright (c) 2013 isaacl.net. All rights reserved.
//

#import "NewInviteeViewController.h"

@interface NewInviteeViewController ()
{
    NSMutableArray *results;
    EUUser *selectedUser;
}
@end

@implementation NewInviteeViewController

@synthesize searchBox, resultsTable, eventName;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	searchBox.delegate = self;
    results = [NSMutableArray array];

    self.navigationItem.leftBarButtonItem =
    [ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"close.png"]
                        selectedImage:[UIImage imageNamed:@"closeSelected.png"]
                               target:self
                               action:@selector(performDismiss)];

    [searchBox becomeFirstResponder];
}

- (BOOL)friend:(FBGraphObject<FBGraphUser> *)friend matchesQuery:(NSString *)query
{
    NSString *first = friend.first_name;
    NSString *last = friend.last_name;
    NSString *username = friend.username;
    if (first.length != 0 && [first rangeOfString:query].location != NSNotFound) return YES;
    if (last.length != 0 && [friend.last_name rangeOfString:query].location != NSNotFound) return YES;
    if (username.length != 0 && [friend.username rangeOfString:query].location != NSNotFound) return YES;
    return NO;
}

- (IBAction)searchFriends:(id)sender
{
    [MBProgressHUD fadeInHUDInView:resultsTable withText:@"Getting friends"];
    
    [results removeAllObjects];
    [resultsTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    
    FBRequest *friendRequest = [FBRequest requestForMyFriends];
    [friendRequest startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        NSArray *myFriends = [result objectForKey:@"data"];

        for (FBGraphObject<FBGraphUser> *friend in myFriends) {
            if ([self friend:friend matchesQuery:searchBox.text]) {
                EUUser *user = [EUUser userFromFBGraphUser:friend];
                [results addObject:user];
            }
        }

        /* Done fetching all data. Reload the UI */
        NSMutableArray *ipArr = [NSMutableArray array];
        for (int i = 0; i < results.count; i++)
            [ipArr addObject:[NSIndexPath indexPathForItem:i inSection:0]];
        [resultsTable insertRowsAtIndexPaths:ipArr withRowAnimation:UITableViewRowAnimationFade];
        
        [MBProgressHUD fadeOutHUDInView:resultsTable withSuccessText:nil];
    }];
}

- (void)performDismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self searchFriends:nil];
    return NO;
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"InviteeCell";
    EUInviteeCell *cell = (EUInviteeCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    // Configure the cell...
    EUUser *user = [results objectAtIndex:indexPath.row];
    cell.nameLabel.text = [user fullName];
    cell.nameLabel.font = kEUFontText;
    [cell.profPic setImageWithURL:user.profPic];

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EUUser *user = [results objectAtIndex:indexPath.row];
    selectedUser = user;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    /* Query server for user */
    EUHTTPClient *client = [EUHTTPClient newClientInView:[[UIView alloc] init]];
    [client getPath:@"/info/user/"
         parameters:@{kEURequestKeyUserUID : [NSNumber numberWithDouble:user.uid]}
        loadingText:@"Checking user"
        successText:nil
            success:^(AFHTTPRequestOperation *operation, NSString *response) {
                NSDictionary *resp = [response JSONValue];
                if ([resp objectForKey:@"error"]) {

                    /* User does not exist, so create a new user! */
                    NSLog(@"Error: %@", [resp objectForKey:@"error"]);
                    NSString *title = [NSString stringWithFormat:@"%@ is not on EatUp!", user.firstName];
                    NSString *msg = [NSString stringWithFormat:@"Would you like to send %@ an email to download the app?", user.firstName];
                    ILAlertView *alert = [ILAlertView showWithTitle:title
                                                            message:msg
                                                   closeButtonTitle:@"Nope"
                                                  secondButtonTitle:@"Yes, please!"];
                    alert.tag = 13; // Magic Number
                    alert.delegate = self;
                }
                else {
                    /* Existing user. Dismiss! */
                    [self dismissViewControllerAnimated:YES completion:nil];
                    [self.delegate didDismissWithNewUser:user];
                }

            }
            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"ERROR: %@", error);

                [ILAlertView showWithTitle:@"Error!"
                                   message:@"Something went wrong :( Please try creating the event again in a few minutes."
                          closeButtonTitle:@"OK"
                         secondButtonTitle:nil];
            }];
}

- (void)alertView:(ILAlertView *)alertView tappedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 13) { //Magic Number
        if (buttonIndex == 1) {
            [self sendEmailTo:selectedUser];
        }
    }
}

- (void)sendEmailTo:(EUUser *)user
{
    // Email Subject
    NSString *emailTitle = @"Download EatUp! - A new approach to social eating.";
    // Email Content
    NSString *messageBody = [NSString stringWithFormat:@"Hey %@,<br><br>I'm trying to invite you to my event: \"%@\", but you don't seem\
                             to have EatUp! installed. Please download it from the iOS App Store at <a href='http://isaacl.net/apps'>this link</a>!", user.firstName, eventName];
    // To address
//    NSArray *toRecipents = [NSArray arrayWithObject:@"support@appcoda.com"];

    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:YES];
    [mc setToRecipients:nil];

    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:nil];
}

#pragma mark - MLMailComposer

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }

    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
