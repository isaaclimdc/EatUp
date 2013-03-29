//
//  ILSelectionViewCategory.h
//  EatUp
//
//  Created by Isaac Lim on 3/16/13.
//  Copyright (c) 2013 isaacl.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ILSelectionViewCategory : NSObject

@property (strong, nonatomic) UIImage *activeButtonImage;
@property (strong, nonatomic) UIImage *inactiveButtonImage;
@property (strong, nonatomic) UIView *contentView;

+ (ILSelectionViewCategory *)categoryWithActiveButtonImage:(UIImage *)activeButtonImage
                                       inactiveButtonImage:(UIImage *)inactiveButtonImage
                                               contentView:(UIView *)contentView;

@end
