//
//  NewMealViewController.m
//  EatUp
//
//  Created by Isaac Lim on 3/2/13.
//  Copyright (c) 2013 isaacl.net. All rights reserved.
//

#import "NewMealViewController.h"

@interface NewMealViewController ()

@end

@implementation NewMealViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.leftBarButtonItem = [ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"gear.png"]
                                                                selectedImage:[UIImage imageNamed:@"gearSelected.png"]
                                                                       target:self
                                                                       action:@selector(dismiss:)];
}

- (void)dismiss:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
