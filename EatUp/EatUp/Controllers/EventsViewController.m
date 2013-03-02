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

    // Fill with random elements
    EUEvent *event = [EUEvent eventWithTitle:@"Birthday Dinner" time:[NSDate date] participants:nil];
    [events addObject:event];
    event = [EUEvent eventWithTitle:@"Party at Brgr!" time:[NSDate dateWithTimeIntervalSinceNow:500] participants:nil];
    [events addObject:event];
    event = [EUEvent eventWithTitle:@"Aunt Lily's Home" time:[NSDate dateWithTimeIntervalSinceNow:12500] participants:nil];
    [events addObject:event];
    event = [EUEvent eventWithTitle:@"Date with Julia" time:[NSDate dateWithTimeIntervalSinceNow:5003500] participants:nil];
    [events addObject:event];

    self.navigationItem.leftBarButtonItem =
    [ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"gear.png"]
                        selectedImage:[UIImage imageNamed:@"gearSelected.png"]
                               target:self
                               action:@selector(showSideMenu:)];

    self.navigationItem.rightBarButtonItem =
    [ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"gear.png"]
                        selectedImage:[UIImage imageNamed:@"gearSelected.png"]
                               target:self
                               action:@selector(showNewMeal:)];
}

- (void)showNewMeal:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UINavigationController *newMealNC = [storyboard instantiateViewControllerWithIdentifier:@"NewMeaNavController"];
    [self presentViewController:newMealNC animated:YES completion:nil];
}

- (void)showSideMenu:(id)sender
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
    cell.titleLabel.text = event.title;
    cell.dateTimeLabel.text = [event stringDate];

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
    MealViewController *mealVC =
        [storyboard instantiateViewControllerWithIdentifier:@"MealViewController"];
    EUEvent *event = [events objectAtIndex:indexPath.row];
    mealVC.event = event;
    
    [self.navigationController pushViewController:mealVC animated:YES];
}

@end
