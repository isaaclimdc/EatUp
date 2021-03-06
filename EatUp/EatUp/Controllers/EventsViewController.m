//
//  EventsViewController.m
//  EatUp
//
//  Created by Isaac Lim on 3/2/13.
//  Copyright (c) 2013 isaacl.net. All rights reserved.
//

#import "EventsViewController.h"

@interface EventsViewController () {
    NSMutableArray *users;
    EUHTTPClient *client;
    NSMutableArray *events;
    UIRefreshControl *refreshControl;
}

@end

@implementation EventsViewController

@synthesize launchedFromSideMenu;

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = kEUBkgColor;

    if (!launchedFromSideMenu) {
        /* Fade out splash screen */
        UIImageView *splash = [[UIImageView alloc] initWithFrame:
                               CGRectMake(0, -20,
                                          self.navigationController.view.frame.size.width,
                                          self.navigationController.view.frame.size.height+20)];

        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            if ([[UIScreen mainScreen] bounds].size.height > 480.0f) {
                /* iPhone 5 */
                splash.image = [UIImage imageNamed:@"Default-568h@2x.png"];
            } else {
                /* iPhone */
                splash.image = [UIImage imageNamed:@"Default.png"];
            }
        } else {
            /* iPad */
        }

        [self.navigationController.view addSubview:splash];
        [UIView animateWithDuration:0.2 animations:^{
            splash.alpha = 0.0;
        } completion:^(BOOL finished) {
            [splash removeFromSuperview];
        }];
    }

    /* Initialize data arrays and HTTP client */
    client = [EUHTTPClient newClientInView:self.view];
    [self performBlock:^{
        [self fetchData];
    } afterDelay:0.1];

    UIImageView *titleIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title.png"]];
    titleIcon.center = self.navigationController.navigationBar.center;
    [self.navigationController.navigationBar addSubview:titleIcon];

    self.navigationItem.leftBarButtonItem =
    [ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"menu.png"]
                        selectedImage:[UIImage imageNamed:@"menuSelected.png"]
                               target:self
                               action:@selector(showSideMenu)];

    self.navigationItem.rightBarButtonItem =
    [ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"add.png"]
                        selectedImage:[UIImage imageNamed:@"addSelected.png"]
                               target:self
                               action:@selector(showNewEvent)];

    /* Initialize Refresh Control */
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(fetchData) forControlEvents:UIControlEventValueChanged];
    [self setRefreshControl:refreshControl];
}

- (void)fetchData
{
    [refreshControl endRefreshing];

    events = [NSMutableArray array];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    
    NSNumber *myUID = [NSNumber numberWithDouble:[[NSUserDefaults standardUserDefaults] doubleForKey:kEUUserDefaultsKeyMyUID]];
    
    if (myUID) {
        [client getPath:@"/info/userevents/"
             parameters:@{@"uid" : myUID}
            loadingText:@"Fetching events"
            successText:nil
                success:^(AFHTTPRequestOperation *operation, NSString *response) {
                    NSDictionary *fetchedEvents = [[response JSONValue] objectForKey:@"events"];
//                    NSLog(@"FETCHED EVENTS: %@", fetchedEvents);

                    for (NSDictionary *params in fetchedEvents) {
                        EUEvent *event = [EUEvent eventFromParams:params];
                        [events addObject:event];
                    }

                    /* Sort events reverse chronologically */
                    [events sortUsingComparator:^NSComparisonResult(EUEvent *event1, EUEvent *event2) {
                        return [event1 compare:event2];
                    }];

                    /* Done fetching all data. Reload the UI */
                    NSMutableArray *ipArr = [NSMutableArray array];
                    for (int i = 0; i < events.count; i++)
                        [ipArr addObject:[NSIndexPath indexPathForItem:i inSection:0]];
                    [self.tableView insertRowsAtIndexPaths:ipArr withRowAnimation:UITableViewRowAnimationFade];
                }
                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"ERROR: %@", error);
                }];
    }
}

- (void)showNewEvent
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UINavigationController *newEventNC = [storyboard instantiateViewControllerWithIdentifier:@"NewEventNavController"];
    NewEventViewController *newEventVC = (NewEventViewController *)newEventNC.topViewController;
    newEventVC.delegate = self;
    [self presentViewController:newEventNC animated:YES completion:nil];
}

- (void)didDismissWithNewEvent:(BOOL)isNew
{
    if (isNew) {
        [self fetchData];
    }
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
    EUEvent *event = [events objectAtIndex:indexPath.row];
    [cell populateWithEvent:event];

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    EUEvent *event = [events objectAtIndex:indexPath.row];

    /* Deletable only if I'm the host */
    if ([self amIHost:event])
        return YES;
    else
        return NO;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        /* Delete this event */
        [self deleteEvent:[events objectAtIndex:indexPath.row]];
    }
}

- (BOOL)amIHost:(EUEvent *)event
{
    double myUID = [[NSUserDefaults standardUserDefaults] doubleForKey:kEUUserDefaultsKeyMyUID];
    return event.host == myUID;
}

- (void)deleteEvent:(EUEvent *)event
{
    [client getPath:@"/delete/event"
         parameters:@{@"eid" : [NSNumber numberWithDouble:event.eid]}
        loadingText:@"Deleting event"
        successText:nil
            success:^(AFHTTPRequestOperation *operation, NSString *response) {
                NSLog(@"SUCCESS: %@", response);
                
                ILAlertView *alert = [ILAlertView showWithTitle:@"Event deleted!"
                                   message:[NSString stringWithFormat:@"The event \"%@\" was successfully deleted.", event.title]
                          closeButtonTitle:@"OK"
                         secondButtonTitle:nil];
                alert.tag = 9; // Magic number
                alert.delegate = self;
            }
            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"ERROR: %@", error);
            }];
}

- (void)alertView:(ILAlertView *)alertView tappedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 9) { // Magic number
        [self fetchData];
    }
}

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
    eventVC.parent = self;
    [self customAnimationToViewController:eventVC];
}

@end
