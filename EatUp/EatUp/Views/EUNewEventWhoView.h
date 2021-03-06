//
//  EUNewEventWhoView.h
//  EatUp
//
//  Created by Isaac Lim on 3/16/13.
//  Copyright (c) 2013 isaacl.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"
#import "NewInviteeViewController.h"

/* Forward declare because inheriting from custom UIScrollView */
@class TPKeyboardAvoidingScrollView;

@interface EUNewEventWhoView : TPKeyboardAvoidingScrollView
<NewInviteeViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *invitees;
}

@property (strong, nonatomic) UIViewController *viewController;
@property (strong, nonatomic) NSMutableArray *invitees;

- (NSDictionary *)serialize;

@end
