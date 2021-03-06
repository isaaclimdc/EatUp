//
//  EUNewEventWhereView.h
//  EatUp
//
//  Created by Isaac Lim on 3/16/13.
//  Copyright (c) 2013 isaacl.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"
#import "EULocation.h"
#import "NewLocationViewController.h"

/* Forward declare because inheriting from custom UIScrollView */
@class TPKeyboardAvoidingScrollView;

@interface EUNewEventWhereView : TPKeyboardAvoidingScrollView
<NewLocationViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *locations;
}

@property (strong, nonatomic) UIViewController *viewController;
@property (strong, nonatomic) NSMutableArray *locations;

- (NSDictionary *)serialize;

@end
