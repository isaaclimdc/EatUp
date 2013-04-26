//
//  EventsViewController.h
//  EatUp
//
//  Created by Isaac Lim on 3/2/13.
//  Copyright (c) 2013 isaacl.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewEventViewController.h"
#import "EventViewController.h"
#import "EUEventCell.h"

@interface EventsViewController : UITableViewController <NewEventViewControllerDelegate, ILAlertViewDelegate>

@property (nonatomic) BOOL launchedFromSideMenu;

- (void)fetchData;

@end
