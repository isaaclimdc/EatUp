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
    NSMutableArray *users;
    ILHTTPClient *client;
}

@end

@implementation EventsViewController

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
    events = [NSMutableArray array];
    users = [NSMutableArray array];
    client = [ILHTTPClient clientWithBaseURL:kEUBaseURL showingHUDInView:self.view];

    [self fetchUsersWithSuccessHandler:^{
        [self fetchData];
    }];
    
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
}

- (void)fetchUsersWithSuccessHandler:(void (^)(void))success
{
    /* GET the database of users (FOR PROTOTYPE ONLY) */
    [client getPath:@"sampleusers.json"
         parameters:nil
        loadingText:@"Getting ready"
        successText:@"Done"
            success:^(AFHTTPRequestOperation *operation, NSString *response) {
                NSArray *allUsers = [[response JSONValue] objectForKey:@"users"];

                for (NSDictionary *dict in allUsers) {
                    EUUser *user = [EUUser userFromParams:dict];
                    [users addObject:user];
                }
                
                [client forceHideHUD];
                success();
            }
            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error when fetching users: %@", error);
            }
     ];
}

- (void)fetchData
{
    /* GET the user's events data */
    [client getPath:@"sampledata.json"
         parameters:nil
        loadingText:@"Fetching data"
        successText:@"Done"
            success:^(AFHTTPRequestOperation *operation, NSString *response) {
                NSDictionary *resDict = [response JSONValue];
//                NSLog(@"%@", resDict);
//                NSDictionary *myInfo = [resDict objectForKey:@"me"];

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
