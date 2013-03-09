//
//  EUEventView.m
//  EatUp
//
//  Created by Isaac Lim on 3/8/13.
//  Copyright (c) 2013 isaacl.net. All rights reserved.
//

#import "EUEventView.h"

@implementation EUEventView

@synthesize event;
@synthesize titleLabel, dateTimeLabel, locationLabel, participantsScrollView, descriptionTextView;

+ (EUEventView *)newEventViewWithFrame:(CGRect)aFrame andEvent:(EUEvent *)anEvent
{
    EUEventView *eventView = [[EUEventView alloc] initWithFrame:aFrame];
    [eventView customizeForEvent:anEvent];
    return eventView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat width = self.frame.size.width - 2*kEUEventHorzBuffer;
        
        /* Date label */
        dateTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kEUEventHorzBuffer,
                                                                  kEUEventHorzBuffer,
                                                                  width,
                                                                  20)];
        dateTimeLabel.font = kEUFontTextItalic;
        dateTimeLabel.textColor = [UIColor grayColor];
        [self addSubview:dateTimeLabel];

        /* Title label */
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kEUEventHorzBuffer,
                                                               CGFloatGetAfterY(dateTimeLabel.frame),
                                                               width,
                                                               30)];
        titleLabel.font = kEUFontTitle;
        [self addSubview:titleLabel];

        /* Location label */
        locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(kEUEventHorzBuffer,
                                                                  CGFloatGetAfterY(titleLabel.frame),
                                                                  width,
                                                                  20)];
        locationLabel.font = kEUFontText;
        [self addSubview:locationLabel];

        /* Participants Scroller */
        participantsScrollView = [[ILSideScrollView alloc] initWithFrame:CGRectMake(0,
                                                                                    CGFloatGetAfterY(locationLabel.frame),
                                                                                    self.frame.size.width,
                                                                                    150)];
        [participantsScrollView setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1.0]
                                    indicatorStyle:UIScrollViewIndicatorStyleBlack
                                   itemBorderColor:kEUMainColor];
        [self addSubview:participantsScrollView];

        /* Description Text View */
        descriptionTextView = [[UITextView alloc] initWithFrame:CGRectMake(kEUEventHorzBuffer,
                                                                           CGFloatGetAfterY(participantsScrollView.frame),
                                                                           width,
                                                                           200)];
        descriptionTextView.font = kEUFontText;
        descriptionTextView.editable = NO;
        descriptionTextView.scrollEnabled = NO;
        [self addSubview:descriptionTextView];

        /* Self customization */
        
    }
    return self;
}

- (void)customizeForEvent:(EUEvent *)anEvent
{
    self.event = anEvent;
    self.dateTimeLabel.text = [self.event dateString];
    self.titleLabel.text = self.event.title;
    self.descriptionTextView.text = self.event.description;
    [self autoResize:descriptionTextView];
    self.locationLabel.text = [self.event locationsString];

    /* Populate side scroll view */
    NSMutableArray *items = [NSMutableArray array];
    for (EUUser *participant in self.event.participants) {
        ILSideScrollViewItem *item = [ILSideScrollViewItem item];
        item.defaultBackgroundImage = [UIImage imageNamed:@"profPlaceholder.png"];
        item.titleFont = kEUFontTitle;
        item.defaultTitleColor = kEUMainColor;
        item.title = [NSString stringWithFormat:@"%c %c", [participant.firstName characterAtIndex:0],
                                                          [participant.lastName characterAtIndex:0]];
        [item setTarget:self action:@selector(pictureTapped:) withObject:participant];
        [items addObject:item];
    }
    [self.participantsScrollView populateSideScrollViewWithItems:items];

    /* Finalize content size */
    self.contentSize = CGSizeMake(self.frame.size.width, CGFloatGetAfterY(descriptionTextView.frame));
}

- (void)pictureTapped:(EUUser *)user
{
    NSLog(@"%@ tapped", [user fullName]);
}

/* Vertically autoresize a UITextView or a UILabel to fit its content */
- (void)autoResize:(UIView *)view
{
    NSString *text;
    UIFont *font;
    if ([view isMemberOfClass:[UITextView class]]) {
        UITextView *textView = (UITextView *)view;
        text = textView.text;
        font = textView.font;
    }
    else if ([view isMemberOfClass:[UILabel class]]) {
        UILabel *label = (UILabel *)view;;
        text = label.text;
        font = label.font;
    }

    CGRect rect = view.frame;
    CGSize newSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(view.frame.size.width, MAXFLOAT)];
    rect.size.height = newSize.height + 4*kEUEventVertBuffer;
    view.frame = rect;
}

CGFloat CGFloatGetAfterY(CGRect rect) {
    return rect.origin.y + rect.size.height + kEUEventVertBuffer;
}

@end
