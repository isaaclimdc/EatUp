//
//  ILSelectionView.h
//  EatUp
//
//  Created by Isaac Lim on 3/16/13.
//  Copyright (c) 2013 isaacl.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ILSelectionViewCategory.h"

@interface ILSelectionView : UIView 

@property (strong, nonatomic) UIView *contentView;

- (void)populateWithCategories:(NSArray *)categories;
- (UIView *)contentViewForIndex:(NSUInteger)index;

@end
