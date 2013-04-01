//
//  NotificationsViewController.m
//  EatUp
//
//  Created by Isaac Lim on 3/18/13.
//  Copyright (c) 2013 isaacl.net. All rights reserved.
//

#import "NotificationsViewController.h"

@interface NotificationsViewController ()
{
    NSMutableArray *events;
    ILHTTPClient *client;
}
@end

@implementation NotificationsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    /* Initialize data arrays and HTTP client */
    events = [NSMutableArray array];
    client = [ILHTTPClient clientWithBaseURL:kEUBaseURL showingHUDInView:self.view];

    [self fetchData];

    self.navigationItem.leftBarButtonItem =
    [ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"menu.png"]
                        selectedImage:[UIImage imageNamed:@"menuSelected.png"]
                               target:self
                               action:@selector(showSideMenu)];
}

- (void)fetchData
{
    /* GET the user's events data */
    [client getPath:@"samplenotifications.json"
         parameters:nil
        loadingText:@"Updating notifications"
        successText:nil
            success:^(AFHTTPRequestOperation *operation, NSString *response) {
                NSDictionary *resDict = [response JSONValue];
                //                NSLog(@"%@", resDict);

                NSDictionary *eventsTmp = [resDict objectForKey:@"events"];
                for (NSDictionary *dict in eventsTmp) {
                    EUEvent *event = [EUEvent eventFromParams:dict];
                    [events addObject:event];
                }

                /* Done fetching all data. Reload the UI */
                [self.tableView reloadData];
            }
            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error when fetching data: %@", error);
            }
     ];
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
    static NSString *CellIdentifier = @"NotificationsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    EUEvent *event = [events objectAtIndex:indexPath.row];
    cell.textLabel.text = event.title;
    cell.detailTextLabel.text = [event relativeDateString];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard"
                                                         bundle:nil];
    EventViewController *eventVC =
    [storyboard instantiateViewControllerWithIdentifier:@"EventViewController"];
    eventVC.title = @"Notifications";
    EUEvent *event = [events objectAtIndex:indexPath.row];
    eventVC.event = event;

    [self customAnimationToViewController:eventVC];
}

@end
