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

    EULocation *loc1 = [EULocation locationFromParams:@{@"EULocationFriendlyName" : @"Lulu's Craig Street"}];
    EULocation *loc2 = [EULocation locationFromParams:@{@"EULocationFriendlyName" : @"Sun Penang"}];
    EULocation *loc3 = [EULocation locationFromParams:@{@"EULocationFriendlyName" : @"P.F. Chang's"}];
    EULocation *loc4 = [EULocation locationFromParams:@{@"EULocationFriendlyName" : @"BRGR"}];

    EUEvent *event;
    
    event = [EUEvent eventFromParams:
             @{
             @"EUEventTitle": @"Birthday Dinner",
             @"EUEventDateTime" : [NSDate date],
             @"EUEventParticipants" : @[user1, user2, user3],
             @"EUEventLocations" : @[loc1, loc3, loc2],
             @"EUEventDescription" : @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque diam ante, condimentum et rhoncus eu, rhoncus vel tortor. Mauris eget odio quam. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi semper commodo sapien, ac consectetur urna vulputate eu. Nam blandit, orci ut porta dictum, magna massa rhoncus est, feugiat venenatis metus enim in felis. Suspendisse luctus, nibh vitae vulputate porttitor, leo elit volutpat sapien, vel aliquam dolor elit sit amet nulla. Nulla dapibus porttitor dolor, in tempus nisi blandit in. Vivamus et lorem sit amet justo pharetra semper. Proin faucibus convallis sem eget ultrices. Proin pulvinar odio quis diam congue feugiat. In id pretium lorem. Curabitur sodales ipsum quis orci eleifend quis facilisis urna blandit.\n\nVestibulum dapibus dolor nec enim facilisis ullamcorper. Vestibulum lobortis purus at leo consectetur feugiat. Fusce sodales metus et tellus auctor auctor. Vivamus porta tristique tellus, in fringilla purus iaculis non. Nam viverra vestibulum augue id elementum. Etiam varius sem a elit mattis consequat. Duis eu nisi nec libero dictum sodales.\n\nVivamus elementum porta augue eu fringilla. Morbi suscipit, magna vitae laoreet faucibus, quam orci venenatis tellus, vitae consequat eros erat nec ligula. Mauris in neque arcu. Nulla id libero massa, ac semper nisi. Nullam egestas erat vitae odio molestie interdum. Curabitur ac auctor arcu. Phasellus mattis fermentum felis, ultrices porttitor urna pulvinar et. Curabitur blandit neque sit amet nunc rhoncus placerat. Curabitur varius orci at erat mollis dictum."
             }];
    [events addObject:event];

    event = [EUEvent eventFromParams:
             @{
             @"EUEventTitle": @"Party at Brgr!",
             @"EUEventDateTime" : [NSDate dateWithTimeIntervalSinceNow:500],
             @"EUEventDescription" : @"Come visit the brand new reopening of Brgr with new daily hours and a brand new menu selection!",
             @"EUEventParticipants" : @[user5, user4],
             @"EUEventLocations" : @[loc4]
             }];
    [events addObject:event];
    
    event = [EUEvent eventFromParams:
             @{
             @"EUEventTitle": @"Aunt Lily's Home",
             @"EUEventDateTime" : [NSDate dateWithTimeIntervalSinceNow:12500],
             @"EUEventDescription" : @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque diam ante, condimentum et rhoncus eu, rhoncus vel tortor. Mauris eget odio quam. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi semper commodo sapien, ac consectetur urna vulputate eu. Nam blandit, orci ut porta dictum, magna massa rhoncus est, feugiat venenatis metus enim in felis. Suspendisse luctus, nibh vitae vulputate porttitor, leo elit volutpat sapien, vel aliquam dolor elit sit amet nulla. Nulla dapibus porttitor dolor, in tempus nisi blandit in. Vivamus et lorem sit amet justo pharetra semper. Proin faucibus convallis sem eget ultrices. Proin pulvinar odio quis diam congue feugiat. In id pretium lorem. Curabitur sodales ipsum quis orci eleifend quis facilisis urna blandit.\n\nVestibulum dapibus dolor nec enim facilisis ullamcorper. Vestibulum lobortis purus at leo consectetur feugiat. Fusce sodales metus et tellus auctor auctor. Vivamus porta tristique tellus, in fringilla purus iaculis non. Nam viverra vestibulum augue id elementum. Etiam varius sem a elit mattis consequat. Duis eu nisi nec libero dictum sodales.\n\nVivamus elementum porta augue eu fringilla. Morbi suscipit, magna vitae laoreet faucibus, quam orci venenatis tellus, vitae consequat eros erat nec ligula. Mauris in neque arcu. Nulla id libero massa, ac semper nisi. Nullam egestas erat vitae odio molestie interdum. Curabitur ac auctor arcu. Phasellus mattis fermentum felis, ultrices porttitor urna pulvinar et. Curabitur blandit neque sit amet nunc rhoncus placerat. Curabitur varius orci at erat mollis dictum.",
             @"EUEventParticipants" : @[],
             @"EUEventLocations" : @[loc3]
             }];
    [events addObject:event];
    
    event = [EUEvent eventFromParams:
             @{
             @"EUEventTitle": @"Fun outing",
             @"EUEventDateTime" : [NSDate dateWithTimeIntervalSinceNow:5003500],
             @"EUEventParticipants" : @[user1, user5, user3, user2, user4],
             @"EUEventLocations" : @[]
             }];
    [events addObject:event];

    event = [EUEvent eventFromParams:
             @{
             @"EUEventTitle": @"Date with Julia",
             @"EUEventDateTime" : [NSDate dateWithTimeIntervalSinceNow:6003500],
             @"EUEventParticipants" : @[user4],
             @"EUEventLocations" : @[loc2]
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
