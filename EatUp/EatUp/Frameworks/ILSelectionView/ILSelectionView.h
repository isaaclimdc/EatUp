//
//  ILSelectionView.h
//  EatUp
//
//  Created by Isaac Lim on 3/16/13.
//  Copyright (c) 2013 isaacl.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ILSelectionViewCategory.h"

@interface ILSelectionView : UIView {
    NSArray *_categories;
    UIView *_contentView;
    UIImageView *_indicator;
    NSUInteger _currentIndex;
}

@property (strong, nonatomic) NSArray *categories;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIImageView *indicator;
@property (nonatomic) NSUInteger currentIndex;

+ (ILSelectionView *)selectionViewWithCategories:(NSArray *)categories inFrame:(CGRect)frame;

@end
