//
//  EventViewController.m
//  EatUp
//
//  Created by Isaac Lim on 3/2/13.
//  Copyright (c) 2013 isaacl.net. All rights reserved.
//

#import "EventViewController.h"

@interface EventViewController ()

@end

@implementation EventViewController

@synthesize eventView, event;

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.leftBarButtonItem =
    [ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"backArrow.png"]
                        selectedImage:[UIImage imageNamed:@"backArrowSelected.png"]
                               target:self
                               action:@selector(goBack:)];

    self.navigationItem.rightBarButtonItem =
    [ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"edit.png"]
                        selectedImage:[UIImage imageNamed:@"editSelected.png"]
                               target:self
                               action:@selector(showEditScreen)];
    
    /* Initialize EUEventView */
    eventView = [EUEventView newEventViewWithFrame:CGRectMake(0,
                                                              0,
                                                              self.view.frame.size.width,
                                                              self.view.frame.size.height
                                                                - self.navigationController.navigationBar.frame.size.height)
                                          andEvent:event];
    [self.view addSubview:eventView];
}

- (IBAction)goBack:(id)sender {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.4;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:
                                 kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromLeft;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showEditScreen
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UINavigationController *newEventNC = [storyboard instantiateViewControllerWithIdentifier:@"NewEventNavController"];
    NewEventViewController *newEventVC = (NewEventViewController *)newEventNC.topViewController;
    newEventVC.existingEvent = self.event;
    [self presentViewController:newEventNC animated:YES completion:nil];
}

- (IBAction)showStatusAlert:(id)sender
{
    NSString *msg = [NSString stringWithFormat:@"The host of \"%@\" will be notified of your RSVP. You may change your response at any time.", self.event.title];

    ILAlertView *alert = [ILAlertView showWithTitle:@"RSVP to this event"
                                            message:msg
                                   closeButtonTitle:@"Decline"
                                  secondButtonTitle:@"Accept"];
    alert.tag = 100;
    alert.delegate = self;
}

- (void)alertView:(ILAlertView *)alertView tappedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100) {
        /* TODO: Eventually put user lookup by uid here */
        NSString *hostName = [NSString stringWithFormat:@"User %.0f", self.event.host];
        NSString *title;
        NSString *msg;

        if (buttonIndex == 0) {
            title = @"You've chosen not to go";
            msg = [NSString stringWithFormat:@"%@ has been informed that you're not going.", hostName];
        }
        else if (buttonIndex == 1) {
            title = @"You're going!";
            msg = [NSString stringWithFormat:@"%@ has been informed that you're going!", hostName];
        }

        [self goBack:nil];
        [ILAlertView showWithTitle:title message:msg closeButtonTitle:@"OK" secondButtonTitle:nil];
    }
}

@end
