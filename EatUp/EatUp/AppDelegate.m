//
//  AppDelegate.m
//  EatUp
//
//  Created by Isaac Lim on 3/2/13.
//  Copyright (c) 2013 isaacl.net. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize navController = _navController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
    // Override point for customization after application launch
    [UIImage patchImageNamedToSupport568Resources];
    sleep(1);

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UINavigationController *eventsNC = [storyboard instantiateInitialViewController];
    SideViewController *sideVC = [storyboard instantiateViewControllerWithIdentifier:@"SideViewController"];

    // PKRevealController.h contains a list of all the specifiable options
    NSDictionary *options = @{
                              PKRevealControllerAllowsOverdrawKey : [NSNumber numberWithBool:YES],
                              PKRevealControllerDisablesFrontViewInteractionKey : [NSNumber numberWithBool:YES],
                              PKRevealControllerRecognizesPanningOnFrontViewKey : @NO
                              };

    // Convenience initializer for a one-sided reveal controller.
    revealController = [PKRevealController revealControllerWithFrontViewController:eventsNC
                                                                leftViewController:sideVC
                                                                           options:options];

    /* Setup another UINavigationController for the Facebook login */
    self.navController = [[UINavigationController alloc] initWithRootViewController:revealController];
    self.navController.navigationBarHidden = YES;
    self.window.rootViewController = self.navController;
    [self.window makeKeyAndVisible];

    // See if we have a valid token for the current state.
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        [self openSession];
    }
    else {
        [self showLoginView];
    }

    [self setupAppearances];

    /*** Setup Urban Airship ***/
    
    //Create Airship options dictionary and add the required UIApplication launchOptions
    NSMutableDictionary *takeOffOptions = [NSMutableDictionary dictionary];
    [takeOffOptions setValue:launchOptions forKey:UAirshipTakeOffOptionsLaunchOptionsKey];

    // Call takeOff (which creates the UAirship singleton), passing in the launch options so the
    // library can properly record when the app is launched from a push notification. This call is
    // required.
    
    // Populate AirshipConfig.plist with your app's info from https://go.urbanairship.com
    [UAirship takeOff:takeOffOptions];

    // Set the icon badge to zero on startup (optional)
    [[UAPush shared] resetBadge];

    // Register for remote notfications with the UA Library. This call is required.
    [[UAPush shared] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                         UIRemoteNotificationTypeSound |
                                                         UIRemoteNotificationTypeAlert)];

    // Handle any incoming incoming push notifications.
    // This will invoke `handleBackgroundNotification` on your UAPushNotificationDelegate.
    [[UAPush shared] handleNotification:[launchOptions valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey]
                       applicationState:application.applicationState];

    return YES;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if (userInfo != nil) {
        NSDictionary *alertDict = [userInfo objectForKey:@"aps"];

        NSString *alert = [NSString stringWithFormat:@"%@\n\nThe events screen has been updated with this event. Please send the host your RSVP!", [alertDict objectForKey:@"alert"]];
        NSLog(@"%@", alert);

        [ILAlertView showWithTitle:@"Incoming invitation!"
                           message:alert
                  closeButtonTitle:@"OK"
                 secondButtonTitle:nil];

        // Do something with the notification dictionary
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        UIViewController *VC = [storyboard instantiateViewControllerWithIdentifier:@"EventsNavController"];
        [revealController setFrontViewController:VC focusAfterChange:YES completion:nil];
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
	NSLog(@"My token is: %@", deviceToken);

    // Updates the device token and registers the token with UA.
    [[UAPush shared] registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
	NSLog(@"Failed to get token, error: %@", error);
}

- (void)setupAppearances
{
    self.window.backgroundColor = [UIColor whiteColor];

    UINavigationBar *navBar = [UINavigationBar appearance];
    [navBar setBackgroundImage:[UIImage imageNamed:@"navBar.png"]
                 forBarMetrics:UIBarMetricsDefault];
    [navBar setShadowImage:[[UIImage alloc] init]];
    [navBar setTintColor:kEUMainColor];

    [navBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor], UITextAttributeTextColor,
                                    [UIColor clearColor], UITextAttributeTextShadowColor,
                                    kEUFontBarTitle, UITextAttributeFont
                                    , nil]];
    [navBar setTitleVerticalPositionAdjustment:-1.0f forBarMetrics:UIBarMetricsDefault];

    UIImage *segmentSelected = [[UIImage imageNamed:@"segcontrol_sel.png"]
                                resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 15)];
    UIImage *segmentUnselected = [[UIImage imageNamed:@"segcontrol_uns.png"]
                                  resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 15)];
    UIImage *segmentSelectedUnselected = [UIImage imageNamed:@"segcontrol_sel-uns.png"];
    UIImage *segUnselectedSelected = [UIImage imageNamed:@"segcontrol_uns-sel.png"];
    UIImage *segmentUnselectedUnselected = [UIImage imageNamed:@"segcontrol_uns-uns.png"];

    UISegmentedControl *segCtrl = [UISegmentedControl appearance];
    [segCtrl setBackgroundImage:segmentUnselected
                       forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [segCtrl setBackgroundImage:segmentSelected
                       forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];

    [segCtrl setDividerImage:segmentUnselectedUnselected
         forLeftSegmentState:UIControlStateNormal
           rightSegmentState:UIControlStateNormal
                  barMetrics:UIBarMetricsDefault];
    [segCtrl setDividerImage:segmentSelectedUnselected
         forLeftSegmentState:UIControlStateSelected
           rightSegmentState:UIControlStateNormal
                  barMetrics:UIBarMetricsDefault];
    [segCtrl setDividerImage:segUnselectedSelected
         forLeftSegmentState:UIControlStateNormal
           rightSegmentState:UIControlStateSelected
                  barMetrics:UIBarMetricsDefault];
    [segCtrl setTitleTextAttributes:@{UITextAttributeFont : kEUFontText} forState:UIControlStateNormal];
}

- (void)showLoginView
{
    UIViewController *topViewController = [self.navController topViewController];
    UIViewController *modalViewController = topViewController.presentedViewController;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];

    /* If the login screen is not already displayed, display it. If the login screen is
     * displayed, then getting back here means the login in progress did not successfully
     * complete. In that case, notify the login view so it can update its UI appropriately.
     */
    if (![modalViewController isKindOfClass:[LoginViewController class]]) {
        LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];

        [topViewController presentViewController:loginViewController
                                        animated:NO
                                      completion:nil];
    }
    else {
        LoginViewController *loginViewController = (LoginViewController *)modalViewController;
        [loginViewController loginFailed];
    }
}

/* Callback from the Facebook app */
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    [self performBlock:^{
        [ILAlertView showWithTitle:@"Logged in!"
                           message:@"You are now logged in to the EatUp! service! Here are your upcoming events."
                  closeButtonTitle:@"OK"
                 secondButtonTitle:nil];
    } afterDelay:0.5];

    return [FBSession.activeSession handleOpenURL:url];
}

#pragma mark - Facebook Auth Methods

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen: {
            //            NSLog(@"Login success");
            UIViewController *topViewController = self.navController.topViewController;
            if ([topViewController.presentedViewController isKindOfClass:[LoginViewController class]]) {
                [topViewController dismissViewControllerAnimated:YES completion:^{
                    UINavigationController *NC = (UINavigationController *)revealController.frontViewController;
                    EventsViewController *VC = (EventsViewController *)NC.topViewController;
                    [VC fetchData];
                }];
            }
        }
            break;
        case FBSessionStateClosed: {
            //            NSLog(@"Logged out");
            [self.navController popToRootViewControllerAnimated:NO];
            [revealController showViewController:revealController.frontViewController];

            [FBSession.activeSession closeAndClearTokenInformation];

            [self showLoginView];
            break;
        }
        case FBSessionStateClosedLoginFailed: {
            //            NSLog(@"Login failed");

            [ILAlertView showWithTitle:@"Login failed!"
                               message:@"It looks like the Facebook login was cancelled. Please try logging in again."
                      closeButtonTitle:@"OK"
                     secondButtonTitle:nil];
            break;
        }
        default:
            break;
    }

    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)openSession
{
    [FBSession openActiveSessionWithReadPermissions:nil
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session,
       FBSessionState state, NSError *error) {
         [self sessionStateChanged:session state:state error:error];

         if (state != FBSessionStateClosed) {
             [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                 NSDictionary *myInfo = (NSDictionary *)result;
                 NSString *myUIDStr = [myInfo objectForKey:@"id"];
                 double myUID = [myUIDStr doubleValue];
                 NSString *myName = [myInfo objectForKey:@"name"];
                 [[NSUserDefaults standardUserDefaults] setDouble:myUID forKey:kEUUserDefaultsKeyMyUID];
                 [[NSUserDefaults standardUserDefaults] setObject:myName forKey:kEUUserDefaultsKeyMyName];

                 NSString *myFirstName = [myInfo objectForKey:@"first_name"];
                 NSString *myLastName = [myInfo objectForKey:@"last_name"];
                 NSNumber *uidObj = [NSNumber numberWithDouble:myUID];

                 NSLog(@"Logged in as %@ (%@).", myName, uidObj);

                 /* Set as alias on UAirship */
                 [[UAPush shared] setAlias:myUIDStr];
                 [[UAPush shared] updateRegistration];

                 /* Query server for user */
                 EUHTTPClient *client = [EUHTTPClient newClientInView:[[UIView alloc] init]];
                 [client getPath:@"/info/user/"
                      parameters:@{kEURequestKeyUserUID : uidObj}
                     loadingText:nil
                     successText:nil
                         success:^(AFHTTPRequestOperation *operation, NSString *response) {
                             NSDictionary *resp = [response JSONValue];
                             if ([resp objectForKey:@"error"]) {

                                 /* User does not exist, so create a new user! */
                                 NSLog(@"Error: %@", [resp objectForKey:@"error"]);
                                 NSDictionary *params = @{kEURequestKeyUserUID : uidObj,
                                                          kEURequestKeyUserFirstName : myFirstName,
                                                          kEURequestKeyUserLastName : myLastName,
                                                          kEURequestKeyUserProfPic : kEUFBUserProfPic(uidObj)
                                                          };
                                 NSLog(@"CREATE USER PARAMS: %@", params);
                                 [client postPath:@"/create/user/"
                                      parameters:params
                                     loadingText:nil
                                     successText:nil
                                    multiPartForm:nil
                                         success:^(AFHTTPRequestOperation *operation, NSString *response) {
                                             NSLog(@"SUCCESS: %@", response);
                                         }
                                         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             NSLog(@"ERROR: %@", error);
                                         }];
                             }
                             else {
                                 /* Existing user. Login and fetch events */
//                                 NSLog(@"FOUND USER!: %@", resp);
                             }

                         }
                         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                             NSLog(@"ERROR: %@", error);
                         }];
             }];
         }
     }];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /* Sent when the application is about to move from active to inactive state. This can occur for certain types
     * of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application
     * and it begins the transition to the background state.
     *
     * Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use
     * this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /* Use this method to release shared resources, save user data, invalidate timers, and store enough application
     * state information to restore your application to its current state in case it is terminated later.
     *
     * If your application supports background execution, this method is called instead of applicationWillTerminate:
     * when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /* Called as part of the transition from the background to the inactive state; here you can undo many of the
     * changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /* Restart any tasks that were paused (or not yet started) while the application was inactive. If the
     * application was previously in the background, optionally refresh the user interface.
     */

    /* We need to properly handle activation of the application with regards to
     * Facebook Login
     * (e.g., returning from iOS 6.0 Login Dialog or from fast app switching).
     */
    [FBSession.activeSession handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /* Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
     */
    [UAirship land];
}

@end
