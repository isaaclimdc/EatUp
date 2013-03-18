//
//  ILSelectionView.m
//  EatUp
//
//  Created by Isaac Lim on 3/16/13.
//  Copyright (c) 2013 isaacl.net. All rights reserved.
//

#import "ILSelectionView.h"

#define kILSelectionViewBuffer 10.0f
#define kILSelectionViewBtnHeight 50.0f

@interface ILSelectionView ()

@property (strong, nonatomic) NSArray *categories;
@property (strong, nonatomic) UIImageView *indicator;
@property (nonatomic) NSUInteger currentIndex;
@property (strong, nonatomic) UIView *contentView1;
@property (strong, nonatomic) UIView *contentView2;
@property (strong, nonatomic) UIView *contentView3;

@end

@implementation ILSelectionView

@synthesize contentView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        /* Custom initialization */
    }
    return self;
}

- (void)populateWithCategories:(NSArray *)categories
{
    /* Raise an exception if categories contains foreign-typed objects */
    if (![ILSelectionView arrayContainsCategoryObjects:categories]) {
        [NSException raise:@"ILSelectionView array of wrong type"
                    format:@"Array passed into selectionViewWithCategories: contains objects that are not of type ILSelectionViewCategory."];
    }

    /* Raise an exception if categories of wrong size */
    if (categories.count > 3) {
        [NSException raise:@"ILSelectionView array of wrong size"
                    format:@"ILSelectionViewCategory array must contain only 3 elements."];
    }

    self.categories = categories;
    
    CGFloat y = kILSelectionViewBuffer*2+kILSelectionViewBtnHeight;
    contentView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                           y,
                                                           self.frame.size.width,
                                                           self.frame.size.height-y-kILSelectionViewBuffer)];
    [self addSubview:contentView];

    /* Category buttons (frames are for a fixed category size of 3 */
    CGFloat width = self.frame.size.width;
    CGFloat btnWidth = 2*width/12;

    for (int i = 0; i < self.categories.count; i++) {
        /* Each button */
        ILSelectionViewCategory *category = [self.categories objectAtIndex:i];

        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        btn.frame = CGRectMake((4*i+1)*width/12,
                               kILSelectionViewBuffer,
                               btnWidth,
                               kILSelectionViewBtnHeight);

        [btn setBackgroundImage:category.buttonImage forState:UIControlStateNormal];
        [btn setBackgroundImage:category.selectedButtonImage forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(categoryTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];

        /* Content View */
        UIView *contentViewi = category.contentView;
        contentViewi.hidden = YES;

        contentViewi.frame = CGRectMake(0,
                                        0,
                                        self.contentView.frame.size.width,
                                        self.contentView.frame.size.height);
        [self.contentView addSubview:contentViewi];

        if (i == 0)
            self.contentView1 = contentViewi;
        else if (i == 1)
            self.contentView2 = contentViewi;
        else if (i == 2)
            self.contentView3 = contentViewi;
    }

    /* Indicator */
    self.indicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"indicator.png"]];
    [self addSubview:self.indicator];

    /* Show first contentView */
    [self changeToCategoryAtIndex:0];
}

- (void)changeToCategoryAtIndex:(NSUInteger)index
{
    assert(self.categories.count > index);

    /* First hide the current one */
    UIView *oldContentView = [self contentViewForIndex:self.currentIndex];
    oldContentView.hidden = YES;

    /* Change contentView */
    UIView *newContentView = [self contentViewForIndex:index];
    newContentView.hidden = NO;

    /* Change currentIndex */
    self.currentIndex = index;

    /* Animate indicator */
    [self centerIndicatorAnimated:YES];
}

- (IBAction)categoryTapped:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    [self changeToCategoryAtIndex:btn.tag];
}

/* Automagically center the indicator based on self.currentIndex */
- (void)centerIndicatorAnimated:(BOOL)animated
{
    CGFloat width = self.frame.size.width;

    CGFloat x = (4*self.currentIndex+2)*width/12 - self.indicator.frame.size.width/2;
    CGFloat y = self.contentView.frame.origin.y - self.indicator.frame.size.height;

    CGRect rect = self.indicator.frame;
    rect.origin.x = x;
    rect.origin.y = y;

    if (animated) {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.indicator.frame = rect;
        } completion:nil];
    }
    else {
        self.indicator.frame = rect;
    }
}

#pragma mark - Helper Methods

/* Returns YES if array contains only ILSelectionViewCategory objects, NO otherwise. */
+ (BOOL)arrayContainsCategoryObjects:(NSArray *)array {
    for (int i = 0; i < array.count; i++)
        if (![array[i] isMemberOfClass:[ILSelectionViewCategory class]])
            return NO;

    return YES;
}

- (UIView *)contentViewForIndex:(NSUInteger)index
{
    ILSelectionViewCategory *category = [self.categories objectAtIndex:index];
    return category.contentView;
}

@end
