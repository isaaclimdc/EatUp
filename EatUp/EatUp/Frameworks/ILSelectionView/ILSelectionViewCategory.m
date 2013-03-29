//
//  ILSelectionViewCategory.m
//  EatUp
//
//  Created by Isaac Lim on 3/16/13.
//  Copyright (c) 2013 isaacl.net. All rights reserved.
//

#import "ILSelectionViewCategory.h"

@implementation ILSelectionViewCategory

@synthesize activeButtonImage, inactiveButtonImage, contentView;

+ (ILSelectionViewCategory *)categoryWithActiveButtonImage:(UIImage *)activeButtonImage
                                       inactiveButtonImage:(UIImage *)inactiveButtonImage
                                               contentView:(UIView *)contentView
{
    ILSelectionViewCategory *category = [[ILSelectionViewCategory alloc] init];
    
    category.activeButtonImage = activeButtonImage;
    category.inactiveButtonImage = inactiveButtonImage;
    category.contentView = contentView;
    
    return category;
}

@end
