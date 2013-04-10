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
}

@end

@implementation EventsViewController

@synthesize eventEIDs;

- (void)viewDidLoad
{
    [super viewDidLoad];

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

    /* Initialize data arrays and HTTP client */
    client = [EUHTTPClient newClientInView:self.view];

    [self performBlock:^{
        [self fetchData:nil];
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
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(fetchData:) forControlEvents:UIControlEventValueChanged];
    [self setRefreshControl:refreshControl];
}

- (IBAction)fetchData:(id)sender
{
    events = [NSMutableArray array];
    NSNumber *myUID = [NSNumber numberWithDouble:[[NSUserDefaults standardUserDefaults] doubleForKey:kEUUserDefaultsKeyMyUID]];

    [client getPath:@"/info/userevents/"
         parameters:@{@"uid" : myUID}
        loadingText:nil
        successText:nil
            success:^(AFHTTPRequestOperation *operation, NSString *response) {
                NSDictionary *fetchedEvents = [[response JSONValue] objectForKey:@"events"];
                NSLog(@"FETCHED EVENTS: %@", fetchedEvents);

                for (NSDictionary *params in fetchedEvents) {
                    EUEvent *event = [EUEvent eventFromParams:params];
                    [events addObject:event];
                }

                /* Sort events reverse chronologically */
                [events sortUsingComparator:^NSComparisonResult(EUEvent *event1, EUEvent *event2) {
                    return [event1 compare:event2];
                }];

                /* Done fetching all data. Reload the UI */
                [self.tableView reloadData];
                [(UIRefreshControl *)sender endRefreshing];
                [client forceHideHUD];
            }
            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"ERROR: %@", error);
            }];
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
    EUEvent *event = [events objectAtIndex:indexPath.row];
    [cell populateWithEvent:event];

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
    EUEvent *event = [events objectAtIndex:indexPath.row];
    eventVC.event = event;
    [self customAnimationToViewController:eventVC];
}

@end
