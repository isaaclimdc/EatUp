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

@synthesize selectionImg;

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.leftBarButtonItem =
    [ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"gear.png"]
                        selectedImage:[UIImage imageNamed:@"gearSelected.png"]
                               target:self
                               action:@selector(performDismiss)];

    self.navigationItem.rightBarButtonItem =
    [ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"gear.png"]
                        selectedImage:[UIImage imageNamed:@"gearSelected.png"]
                               target:self
                               action:@selector(performSave)];
}

- (IBAction)changeToWhen:(id)sender
{
    selectionImg.image = [UIImage imageNamed:@"when.png"];
}

- (IBAction)changeToWhere:(id)sender
{
    selectionImg.image = [UIImage imageNamed:@"where.png"];
}

- (IBAction)changeToWho:(id)sender
{
    selectionImg.image = [UIImage imageNamed:@"who.png"];
}

- (void)performSave
{
    NSLog(@"Saving...");
    
    [self performDismiss];
}

- (void)performDismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
