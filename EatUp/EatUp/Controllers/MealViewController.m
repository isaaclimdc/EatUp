//
//  MealViewController.m
//  EatUp
//
//  Created by Isaac Lim on 3/2/13.
//  Copyright (c) 2013 isaacl.net. All rights reserved.
//

#import "MealViewController.h"

@interface MealViewController ()

@end

@implementation MealViewController

@synthesize event;

- (void)viewDidLoad
{
    [super viewDidLoad];

    ILBarButtonItem *backBtn = [ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"gear"]
                                                   selectedImage:[UIImage imageNamed:@"gearSelected.png"]
                                                          target:self
                                                          action:@selector(goBack:)];
    self.navigationItem.leftBarButtonItem = backBtn;
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
