//
//  NewEventViewController.m
//  EatUp
//
//  Created by Isaac Lim on 3/2/13.
//  Copyright (c) 2013 isaacl.net. All rights reserved.
//

#import "NewEventViewController.h"

#define kEUNewEventViewSelectionViewBuffer 10.0f

@interface NewEventViewController ()
{
    EUNewEventWhenView *whenView;
    EUNewEventWhereView *whereView;
    EUNewEventWhoView *whoView;
}
@end

@implementation NewEventViewController

@synthesize sView;

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.leftBarButtonItem =
    [ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"close.png"]
                        selectedImage:[UIImage imageNamed:@"closeSelected.png"]
                               target:self
                               action:@selector(performDismiss)];

    self.navigationItem.rightBarButtonItem =
    [ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"save.png"]
                        selectedImage:[UIImage imageNamed:@"saveSelected.png"]
                               target:self
                               action:@selector(performSave)];

    /* Setup Selection View */
    sView = [[ILSelectionView alloc] initWithFrame:CGRectMake(kEUNewEventViewSelectionViewBuffer,
                                                              0,
                                                              self.view.frame.size.width-kEUNewEventViewSelectionViewBuffer*2,
                                                              self.view.frame.size.height
                                                              - self.navigationController.navigationBar.frame.size.height)];

    /* "When" view */
    whenView = [[EUNewEventWhenView alloc] initWithFrame:sView.frame];
    ILSelectionViewCategory *whenCat =
    [ILSelectionViewCategory categoryWithActiveButtonImage:[UIImage imageNamed:@"whenButtonActive.png"]
                                       inactiveButtonImage:[UIImage imageNamed:@"whenButtonInactive.png"]
                                               contentView:whenView];

    /* "Where" view */
    whereView = [[EUNewEventWhereView alloc] initWithFrame:sView.frame];
    whereView.viewController = self;
    ILSelectionViewCategory *whereCat =
    [ILSelectionViewCategory categoryWithActiveButtonImage:[UIImage imageNamed:@"whereButtonActive.png"]
                                       inactiveButtonImage:[UIImage imageNamed:@"whereButtonInactive.png"]
                                               contentView:whereView];

    /* "Who" view */
    whoView = [[EUNewEventWhoView alloc] initWithFrame:sView.frame];
    whoView.viewController = self;
    ILSelectionViewCategory *whoCat =
    [ILSelectionViewCategory categoryWithActiveButtonImage:[UIImage imageNamed:@"whoButtonActive.png"]
                                       inactiveButtonImage:[UIImage imageNamed:@"whoButtonInactive.png"]
                                               contentView:whoView];

    [sView populateWithCategories:[NSArray arrayWithObjects:whenCat, whereCat, whoCat, nil]];
    sView.contentView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    sView.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    sView.contentView.layer.borderWidth = 1.0;

    [self.view addSubview:sView];
}

- (void)showNewLocation
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UINavigationController *newLocNC = [storyboard instantiateViewControllerWithIdentifier:@"NewLocationNavController"];
    NewLocationViewController *newLocVC = (NewLocationViewController *)newLocNC.topViewController;
    newLocVC.delegate = whereView;
    [self presentViewController:newLocNC animated:YES completion:nil];
}

- (void)showNewInvitees
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UINavigationController *newInvNC = [storyboard instantiateViewControllerWithIdentifier:@"NewInviteeNavController"];
    NewInviteeViewController *newInvVC = (NewInviteeViewController *)newInvNC.topViewController;
    newInvVC.delegate = whoView;
    [self presentViewController:newInvNC animated:YES completion:nil];
}

- (BOOL)isCompleteData:(NSDictionary *)data
{
    if (![data objectForKey:kEURequestKeyEventTitle]) return NO;
    if (![data objectForKey:kEURequestKeyEventDateTime]) return NO;
    if (![data objectForKey:kEURequestKeyEventLocations]) return NO;
    return YES;
}

- (void)performSave
{
    NSMutableDictionary *payload = [NSMutableDictionary dictionary];

    [payload addEntriesFromDictionary:[whenView serialize]];
    [payload addEntriesFromDictionary:[whereView serialize]];
    [payload addEntriesFromDictionary:[whoView serialize]];

    NSLog(@"Payload: %@", payload);

    if ([self isCompleteData:payload]) {
        [ILAlertView showWithTitle:@"Done!"
                           message:@"Your new meal has been created, and the invitees have been sent a notification to join."
                  closeButtonTitle:@"OK"
                 secondButtonTitle:nil];

        [self performDismiss];
    }
    else {
        [ILAlertView showWithTitle:@"Incomplete!"
                           message:@"Please fill in all fields in order to create your new meal."
                  closeButtonTitle:@"OK"
                 secondButtonTitle:nil];
    }
}

- (void)performDismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
