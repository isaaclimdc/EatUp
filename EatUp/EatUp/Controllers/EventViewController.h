//
//  EventViewController.h
//  EatUp
//
//  Created by Isaac Lim on 3/2/13.
//  Copyright (c) 2013 isaacl.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EUEventView.h"

@interface EventViewController : UIViewController <ILAlertViewDelegate> {
    EUEventView *eventView;
}

@property (strong, nonatomic) IBOutlet EUEventView *eventView;
@property (strong, nonatomic) EUEvent *event;

@end
