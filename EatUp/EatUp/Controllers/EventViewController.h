//
//  EventViewController.h
//  EatUp
//
//  Created by Isaac Lim on 3/2/13.
//  Copyright (c) 2013 isaacl.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EUEventView.h"
#import "NewEventViewController.h"
#import "EventsViewController.h"
#import "LocationsViewController.h"

@interface EventViewController : UIViewController <ILAlertViewDelegate, NewEventViewControllerDelegate> {
    EUEventView *eventView;
    EventsViewController *parent;
}

@property (strong, nonatomic) IBOutlet EUEventView *eventView;
@property (strong, nonatomic) EUEvent *event;
@property (strong, nonatomic) EventsViewController *parent;

- (void)locationTapped;

@end
