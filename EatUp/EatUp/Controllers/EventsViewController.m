//
//  EventsViewController.m
//  EatUp
//
//  Created by Isaac Lim on 3/2/13.
//  Copyright (c) 2013 isaacl.net. All rights reserved.
//

#import "EventsViewController.h"

@interface EventsViewController () {
    NSMutableArray *events;
}

@end

@implementation EventsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    events = [NSMutableArray array];

    [self sampleData];

    self.navigationItem.leftBarButtonItem =
    [ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"gear.png"]
                        selectedImage:[UIImage imageNamed:@"gearSelected.png"]
                               target:self
                               action:@selector(showSideMenu)];

    self.navigationItem.rightBarButtonItem =
    [ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"gear.png"]
                        selectedImage:[UIImage imageNamed:@"gearSelected.png"]
                               target:self
                               action:@selector(showNewEvent)];
}

/* Insert random elements */
- (void)sampleData
{
    EUUser *user1 = [EUUser userFromParams:@{@"EUUserFirstName" : @"Michael", @"EUUserLastName" : @"Stone"}];
    EUUser *user2 = [EUUser userFromParams:@{@"EUUserFirstName" : @"Katherine", @"EUUserLastName" : @"Lee"}];
    EUUser *user3 = [EUUser userFromParams:@{@"EUUserFirstName" : @"John", @"EUUserLastName" : @"Mitchell"}];
    EUUser *user4 = [EUUser userFromParams:@{@"EUUserFirstName" : @"Julia", @"EUUserLastName" : @"Green"}];
    EUUser *user5 = [EUUser userFromParams:@{@"EUUserFirstName" : @"Wendy", @"EUUserLastName" : @"Krafts"}];

    EUEvent *event;
    
    event = [EUEvent eventFromParams:
             @{
             @"EUEventTitle": @"Birthday Dinner",
             @"EUEventDateTime" : [NSDate date],
             @"EUEventParticipants" : @[user1, user2, user3]
             }];
    [events addObject:event];

    event = [EUEvent eventFromParams:
             @{
             @"EUEventTitle": @"Party at Brgr!",
             @"EUEventDateTime" : [NSDate dateWithTimeIntervalSinceNow:500],
             @"EUEventDescription" : @"Come visit the brand new reopening of Brgr with new daily hours and a brand new menu selection!",
             @"EUEventParticipants" : @[user5, user4]
             }];
    [events addObject:event];
    
    event = [EUEvent eventFromParams:
             @{
             @"EUEventTitle": @"Aunt Lily's Home",
             @"EUEventDateTime" : [NSDate dateWithTimeIntervalSinceNow:12500],
             @"EUEventParticipants" : @[]
             }];
    [events addObject:event];
    
    event = [EUEvent eventFromParams:
             @{
             @"EUEventTitle": @"Fun outing",
             @"EUEventDateTime" : [NSDate dateWithTimeIntervalSinceNow:5003500],
             @"EUEventParticipants" : @[user1, user5, user3, user2, user4]
             }];
    [events addObject:event];

    event = [EUEvent eventFromParams:
             @{
             @"EUEventTitle": @"Date with Julia",
             @"EUEventDateTime" : [NSDate dateWithTimeIntervalSinceNow:6003500],
             @"EUEventParticipants" : @[user4]
             }];
    [events addObject:event];
}

- (void)showNewEvent
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UINavigationController *newEventNC = [storyboard instantiateViewControllerWithIdentifier:@"NewEventNavController"];
    [self presentViewController:newEventNC animated:YES completion:nil];
}

- (void)showSideMenu
{
    UIViewController *VC;

    if (self.navigationController.revealController.focusedController ==
        self.navigationController.revealController.leftViewController)
    {
        VC = self.navigationController.revealController.frontViewController;
    }
    else
    {
        VC = self.navigationController.revealController.leftViewController;
    }

    [self.navigationController.revealController showViewController:VC];
}

- (void)customAnimationToViewController:(UIViewController *)viewController {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.4;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:
                                 kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromRight;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];

    [self.navigationController pushViewController:viewController animated:YES];
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
    return events.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EventCell";
    EUEventCell *cell = (EUEventCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    // Configure the cell...
    NSUInteger row = indexPath.row;
    EUEvent *event = [events objectAtIndex:row];
    [cell populateWithEvent:event];

    return cell;
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard"
                                                         bundle:nil];
    EventViewController *eventVC =
    [storyboard instantiateViewControllerWithIdentifier:@"EventViewController"];
    EUEvent *event = [events objectAtIndex:indexPath.row];
    eventVC.event = event;

    [self customAnimationToViewController:eventVC];
}

@end
