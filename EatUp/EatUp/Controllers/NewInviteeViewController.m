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
}
@end

@implementation NewInviteeViewController

@synthesize searchBox, resultsTable;

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
    
    FBRequest *friendRequest = [FBRequest requestForMyFriends];
    [friendRequest startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        NSArray *myFriends = [result objectForKey:@"data"];
//        NSLog(@"%@", myFriends);

        for (FBGraphObject<FBGraphUser> *friend in myFriends) {
            if ([self friend:friend matchesQuery:searchBox.text]) {
                EUUser *user = [EUUser userFromFBGraphUser:friend];
                [results addObject:user];
            }
        }

        /* Done. Update UI */
        [resultsTable reloadData];
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
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.delegate didDismissWithNewUser:user];
}

@end
