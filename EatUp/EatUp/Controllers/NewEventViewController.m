//
//  NewEventViewController.m
//  EatUp
//
//  Created by Isaac Lim on 3/2/13.
//  Copyright (c) 2013 isaacl.net. All rights reserved.
//

#import "NewEventViewController.h"
#import "AFJSONRequestOperation.h"

#define kEUNewEventViewSelectionViewBuffer 10.0f
#define IS_EDIT (existingEvent != nil)

@interface NewEventViewController ()
{
    EUNewEventWhenView *whenView;
    EUNewEventWhereView *whereView;
    EUNewEventWhoView *whoView;
}
@end

@implementation NewEventViewController

@synthesize sView, existingEvent, delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = kEUBkgColor;

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

    if (IS_EDIT) {
        [self populateWithExistingData];
        self.title = @"Edit this event";
    }
}

- (void)populateWithExistingData
{
    /* Populate whenView */
    whenView.titleBox.text = existingEvent.title;
    whenView.descriptionBox.text = existingEvent.description;
    whenView.eventDateTime = existingEvent.dateTime;
    [whenView updateDateTimeLabel];

    /* Populate whereView */
    whereView.locations = existingEvent.locations;

    /* Populate whoView */
    NSMutableArray *parts = [existingEvent.participants mutableCopy];
    NSUInteger meIdx = [parts indexOfObjectPassingTest:^BOOL(EUUser *user, NSUInteger idx, BOOL *stop) {
        return user.uid == [[NSUserDefaults standardUserDefaults] doubleForKey:kEUUserDefaultsKeyMyUID];
    }];
    if (meIdx != NSNotFound)
        [parts removeObjectAtIndex:meIdx];
    whoView.invitees = parts;
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
    newInvVC.eventName = whenView.titleBox.text; // Tentative event name
    [self presentViewController:newInvNC animated:YES completion:nil];
}

- (BOOL)isCompleteData:(NSDictionary *)data
{
    if (((NSString *)[data objectForKey:kEURequestKeyEventTitle]).length == 0) return NO;
    if (((NSArray *)[data objectForKey:kEURequestKeyEventLocations]).count == 0) return NO;
    return YES;
}

- (void)performSave
{
    [self hideKeyboard];
    
    NSMutableDictionary *payload = [NSMutableDictionary dictionary];

    NSDictionary *whenDict = [whenView serialize];
    NSDictionary *whereDict = [whereView serialize];
    NSDictionary *whoDict = [whoView serialize];

    [payload addEntriesFromDictionary:whenDict];
    [payload addEntriesFromDictionary:whereDict];
    [payload addEntriesFromDictionary:whoDict];
    
    NSString *path;

    if (IS_EDIT) {
        path = @"/edit/event/";
        [payload setObject:[NSNumber numberWithDouble:existingEvent.eid] forKey:kEURequestKeyEventEID];
    }
    else {
        path = @"/create/event/";
    }

    NSLog(@"Payload: %@", payload);

    if ([self isCompleteData:payload]) {
        EUHTTPClient *client = [EUHTTPClient newClientInView:self.view];
        [client postPath:path
              parameters:payload
             loadingText:(IS_EDIT ? @"Editing details" : @"Creating meal")
             successText:@""
           multiPartForm:nil
                 success:^(AFHTTPRequestOperation *operation, NSString *response) {
                     NSLog(@"SUCCESS!: %@", response);

                     NSArray *participants = [whoDict objectForKey:kEURequestKeyEventParticipants];

                     if (IS_EDIT && (participants.count <= existingEvent.participants.count)) {
                         [ILAlertView showWithTitle:@"Details edited!"
                                            message:@"The details of this meal have been successfully modified!"
                                   closeButtonTitle:@"OK"
                                  secondButtonTitle:nil];

                         [self performDismiss];
                         [self.delegate didDismissWithNewEvent:NO];
                     }
                     else {
                         
                         NSString *title = [whenDict objectForKey:kEURequestKeyEventTitle];
                         NSString *myName = [[NSUserDefaults standardUserDefaults] objectForKey:kEUUserDefaultsKeyMyName];
                         NSString *msg = [NSString stringWithFormat:@"%@ invited you to \"%@\"!", myName, title];
                         [self sendPushNotificationsTo:participants withMessage:msg];
                     }
                 }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     NSLog(@"ERROR: %@, %@", operation.request.HTTPBody, error);

                     [ILAlertView showWithTitle:@"Error!"
                                        message:@"Something went wrong :( Please try creating the event again in a few minutes."
                               closeButtonTitle:@"OK"
                              secondButtonTitle:nil];
                 }];
    }
    else {
        [ILAlertView showWithTitle:@"Incomplete!"
                           message:@"Please fill in all fields in order to create your new meal."
                  closeButtonTitle:@"OK"
                 secondButtonTitle:nil];
    }
}

- (void)sendPushNotificationsTo:(NSArray *)participants withMessage:(NSString *)msg
{
    /* Convert uid NSNumbers to NSStrings */
    NSMutableArray *participantsStr = [NSMutableArray array];
    
    NSNumber *myUID = [NSNumber numberWithDouble:[[NSUserDefaults standardUserDefaults] doubleForKey:kEUUserDefaultsKeyMyUID]];
    for (NSNumber *num in participants) {
        if (![num isEqualToNumber:myUID]) {
            [participantsStr addObject:[NSString stringWithFormat:@"%@", num]];
        }
    }
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kEUUAirshipURL]];

    /* Basic Auth */
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", kEUAppKey, kEUAppMasterSecret];
    NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedString]];

    /* Set header fields */
    [req setValue:authValue forHTTPHeaderField:@"Authorization"];
    [req setHTTPMethod:@"POST"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    /* Set POST Body */
    NSDictionary *dataDict = @{@"aliases": participantsStr,
                               @"aps" : @{@"alert" : msg,
                                          @"sound" : @"default"}};
    [req setHTTPBody:[NSJSONSerialization dataWithJSONObject:dataDict options:NSJSONWritingPrettyPrinted error:nil]];

    /* Off you go! */
    NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:req delegate:self];
    [connection start];
}

- (void)performDismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)hideKeyboard
{
    for (UIView *view in self.view.subviews) {
        [view resignFirstResponder];
    }
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [ILAlertView showWithTitle:@"Meal created!"
                       message:@"The invitees to your meal, if any, have been sent a notification to RSVP."
              closeButtonTitle:@"OK"
             secondButtonTitle:nil];

    [self performDismiss];
    [self.delegate didDismissWithNewEvent:YES];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"ERROR: %@", error);

    [ILAlertView showWithTitle:@"Error!"
                       message:@"Something went wrong :( Please try creating the event again in a few minutes."
              closeButtonTitle:@"OK"
             secondButtonTitle:nil];
}

@end
