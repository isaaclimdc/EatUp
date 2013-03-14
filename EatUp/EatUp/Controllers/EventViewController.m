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

    ILBarButtonItem *backBtn = [ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"backArrow.png"]
                                                   selectedImage:[UIImage imageNamed:@"backArrowSelected.png"]
                                                          target:self
                                                          action:@selector(goBack:)];
    self.navigationItem.leftBarButtonItem = backBtn;

    /* Initialize EUEventView */
    eventView = [EUEventView newEventViewWithFrame:CGRectMake(0,
                                                              0,
                                                              self.view.frame.size.width,
                                                              self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height)
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

@end
