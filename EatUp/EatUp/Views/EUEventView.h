//
//  EUEventView.h
//  EatUp
//
//  Created by Isaac Lim on 3/8/13.
//  Copyright (c) 2013 isaacl.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EUEvent.h"
#import "EventViewController.h"

@class EventViewController;

@interface EUEventView : UIScrollView

@property (strong, nonatomic) EUEvent *event;
@property (strong, nonatomic) EventViewController *parentVC;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UISegmentedControl *goingSegCtrl;
@property (strong, nonatomic) IBOutlet ILSideScrollView *participantsScrollView;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;

+ (EUEventView *)newEventViewWithFrame:(CGRect)aFrame
                                 event:(EUEvent *)anEvent
                                parent:(EventViewController *)parentVC;
- (void)customizeForEvent:(EUEvent *)anEvent;

@end
