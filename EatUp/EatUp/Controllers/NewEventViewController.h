//
//  NewEventViewController.h
//  EatUp
//
//  Created by Isaac Lim on 3/2/13.
//  Copyright (c) 2013 isaacl.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ILSelectionView.h"
#import "EUEvent.h"
#import "EUNewEventWhenView.h"
#import "EUNewEventWhereView.h"
#import "EUNewEventWhoView.h"
#import "NewLocationViewController.h"
#import "NewInviteeViewController.h"

@protocol NewEventViewControllerDelegate <NSObject>

- (void)didDismissWithNewEvent:(BOOL)isNew;

@end

@interface NewEventViewController : UIViewController {
    ILSelectionView *sView;
    EUEvent *existingEvent;
}

@property (nonatomic, weak) id <NewEventViewControllerDelegate> delegate;
@property (strong, nonatomic) ILSelectionView *sView;
@property (strong, nonatomic) EUEvent *existingEvent;

@end
