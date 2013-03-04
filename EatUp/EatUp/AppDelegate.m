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
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UINavigationController *eventsNC = [storyboard instantiateInitialViewController];
    SideViewController *sideVC = [storyboard instantiateViewControllerWithIdentifier:@"SideViewController"];

    // PKRevealController.h contains a list of all the specifiable options
    NSDictionary *options = @{
                              PKRevealControllerAllowsOverdrawKey : [NSNumber numberWithBool:YES],
                              PKRevealControllerDisablesFrontViewInteractionKey : [NSNumber numberWithBool:YES]
                              };

    // Convenience initializer for a one-sided reveal controller.
    PKRevealController *revealController = [PKRevealController revealControllerWithFrontViewController:eventsNC
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

    return YES;
}

- (void)setupAppearances
{
    self.window.backgroundColor = [UIColor whiteColor];
    
    UINavigationBar *navBar = [UINavigationBar appearance];
    [navBar setBackgroundImage:[UIImage imageNamed:@"navBar.png"]
                 forBarMetrics:UIBarMetricsDefault];
    [navBar setTintColor:kEUMainColor];

//    [navBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                    [UIColor whiteColor], UITextAttributeTextColor,
//                                    [UIColor grayColor], UITextAttributeTextShadowColor,
//                                    [UIFont fontWithName:@"Futura-CondensedExtraBold" size:23], UITextAttributeFont
//                                    , nil]];
//    [navBar setTitleVerticalPositionAdjustment:-3.0f forBarMetrics:UIBarMetricsDefault];
}

- (void)showLoginView
{
    UIViewController *topViewController = [self.navController topViewController];
    UIViewController *modalViewController = [topViewController modalViewController];
    
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
        LoginViewController* loginViewController = (LoginViewController*)modalViewController;
        [loginViewController loginFailed];
    }
}

/* Callback from the Facebook app */
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [FBSession.activeSession handleOpenURL:url];
}

#pragma mark - Facebook Auth Methods

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen: {
            UIViewController *topViewController =
            [self.navController topViewController];
            if ([[topViewController modalViewController]
                 isKindOfClass:[LoginViewController class]]) {
                [topViewController dismissModalViewControllerAnimated:YES];
            }
        }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            // Once the user has logged in, redirect them to the root view.
            [self.navController popToRootViewControllerAnimated:NO];

            [FBSession.activeSession closeAndClearTokenInformation];

            [self showLoginView];
            break;
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
         NSLog(@"%@", session.accessTokenData.accessToken);
         [self sessionStateChanged:session state:state error:error];
     }];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

    /* We need to properly handle activation of the application with regards to
     * Facebook Login
     * (e.g., returning from iOS 6.0 Login Dialog or from fast app switching).
     */
    [FBSession.activeSession handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
