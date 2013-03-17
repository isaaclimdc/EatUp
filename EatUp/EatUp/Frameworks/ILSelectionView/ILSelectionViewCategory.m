//
//  ILSelectionViewCategory.m
//  EatUp
//
//  Created by Isaac Lim on 3/16/13.
//  Copyright (c) 2013 isaacl.net. All rights reserved.
//

#import "ILSelectionViewCategory.h"

@implementation ILSelectionViewCategory

@synthesize buttonImage, selectedButtonImage, contentView;

+ (ILSelectionViewCategory *)categoryWithButtonImage:(UIImage *)buttonImage
                                 selectedButtonImage:(UIImage *)selectedButtonImage
                                        contentView:(UIView *)contentView
{
    ILSelectionViewCategory *category = [[ILSelectionViewCategory alloc] init];
    
    category.buttonImage = buttonImage;
    category.selectedButtonImage = selectedButtonImage;
    category.contentView = contentView;
    
    return category;
}

@end
