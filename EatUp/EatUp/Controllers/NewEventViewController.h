//
//  NewEventViewController.h
//  EatUp
//
//  Created by Isaac Lim on 3/2/13.
//  Copyright (c) 2013 isaacl.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ILSelectionView.h"
#import "EUNewEventWhenView.h"
#import "EUNewEventWhereView.h"
#import "EUNewEventWhoView.h"
#import "NewLocationViewController.h"

@interface NewEventViewController : UIViewController {
    ILSelectionView *sView;
}

@property (strong, nonatomic) ILSelectionView *sView;

@end
