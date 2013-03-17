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

/* Forward declare because inheriting from custom UIScrollView */
@class TPKeyboardAvoidingScrollView;

@interface EUNewEventWhereView : TPKeyboardAvoidingScrollView

- (NSDictionary *)serialize;

@end
