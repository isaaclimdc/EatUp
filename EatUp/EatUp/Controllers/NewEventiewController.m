//
//  NewEventViewController.m
//  EatUp
//
//  Created by Isaac Lim on 3/2/13.
//  Copyright (c) 2013 isaacl.net. All rights reserved.
//

#import "NewEventViewController.h"

@interface NewEventViewController ()

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

    UIView *view1 = [[UIView alloc] initWithFrame:self.view.frame];
    view1.backgroundColor = [UIColor blueColor];
    ILSelectionViewCategory *cat1 = [ILSelectionViewCategory categoryWithButtonImage:[UIImage imageNamed:@"close.png"]
                                                                 selectedButtonImage:[UIImage imageNamed:@"closeSelected.png"]
                                                                         contentView:view1
                                                                               title:nil];
    
    UIView *view2 = [[UIView alloc] initWithFrame:self.view.frame];
    view2.backgroundColor = [UIColor yellowColor];
    ILSelectionViewCategory *cat2 = [ILSelectionViewCategory categoryWithButtonImage:[UIImage imageNamed:@"add.png"]
                                                                 selectedButtonImage:[UIImage imageNamed:@"addSelected.png"]
                                                                         contentView:view2
                                                                               title:nil];
    
    UIView *view3 = [[UIView alloc] initWithFrame:self.view.frame];
    view3.backgroundColor = [UIColor greenColor];
    ILSelectionViewCategory *cat3 = [ILSelectionViewCategory categoryWithButtonImage:[UIImage imageNamed:@"menu.png"]
                                                                 selectedButtonImage:[UIImage imageNamed:@"menuSelected.png"]
                                                                         contentView:view3
                                                                               title:nil];
    
    NSArray *categories = [NSArray arrayWithObjects:cat1, cat2, cat3, nil];
    sView = [ILSelectionView selectionViewWithCategories:categories inFrame:self.view.frame];
    [self.view addSubview:sView];
}

- (void)performSave
{
    [ILAlertView showWithTitle:@"Done!"
                       message:@"Your new meal has been created."
              closeButtonTitle:@"OK"
             secondButtonTitle:nil];
    
    [self performDismiss];
}

- (void)performDismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
