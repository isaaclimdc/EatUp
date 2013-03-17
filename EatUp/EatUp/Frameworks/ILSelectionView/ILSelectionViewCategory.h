//
//  ILSelectionViewCategory.h
//  EatUp
//
//  Created by Isaac Lim on 3/16/13.
//  Copyright (c) 2013 isaacl.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ILSelectionViewCategory : NSObject

@property (strong, nonatomic) UIImage *buttonImage;
@property (strong, nonatomic) UIImage *selectedButtonImage;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) NSString *title;

+ (ILSelectionViewCategory *)categoryWithButtonImage:(UIImage *)buttonImage
                                 selectedButtonImage:(UIImage *)selectedButtonImage
                                         contentView:(UIView *)contentView
                                               title:(NSString *)title;

@end
