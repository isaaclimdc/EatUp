//
//  MealViewController.h
//  EatUp
//
//  Created by Isaac Lim on 3/2/13.
//  Copyright (c) 2013 isaacl.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EUEvent.h"

@interface MealViewController : UIViewController {
    EUEvent *event;
}

@property (strong, nonatomic) EUEvent *event;

@end
