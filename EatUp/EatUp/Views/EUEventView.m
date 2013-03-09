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

CGFloat CGFloatGetAfterY(CGRect rect) {
    return rect.origin.y + rect.size.height + kEUEventVertBuffer;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat width = self.frame.size.width - 2*kEUEventHorzBuffer;
        
        /* Date label */
        dateTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kEUEventHorzBuffer,
                                                                  kEUEventVertBuffer,
                                                                  width,
                                                                  30)];
        dateTimeLabel.font = [UIFont italicSystemFontOfSize:18];
        dateTimeLabel.textColor = [UIColor grayColor];
        dateTimeLabel.backgroundColor = [UIColor greenColor];
        [self addSubview:dateTimeLabel];

        /* Title label */
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kEUEventHorzBuffer,
                                                               CGFloatGetAfterY(dateTimeLabel.frame),
                                                               width,
                                                               50)];
        titleLabel.font = [UIFont boldSystemFontOfSize:30];
        titleLabel.backgroundColor = [UIColor blueColor];
        [self addSubview:titleLabel];

        /* Location label */
        locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(kEUEventHorzBuffer,
                                                                  CGFloatGetAfterY(titleLabel.frame),
                                                                  width,
                                                                  30)];
        locationLabel.backgroundColor = [UIColor grayColor];
        [self addSubview:locationLabel];

        /* Participants Scroller */
        participantsScrollView = [[ILSideScrollView alloc] initWithFrame:CGRectMake(kEUEventHorzBuffer,
                                                                                    CGFloatGetAfterY(locationLabel.frame),
                                                                                    width,
                                                                                    150)];
        [participantsScrollView setBackgroundColor:[UIColor redColor]
                                    indicatorStyle:UIScrollViewIndicatorStyleBlack
                                   itemBorderColor:kEUMainColor];
        [self addSubview:participantsScrollView];

        /* Description Text View */
        descriptionTextView = [[UITextView alloc] initWithFrame:CGRectMake(kEUEventHorzBuffer,
                                                                           CGFloatGetAfterY(participantsScrollView.frame),
                                                                           width,
                                                                           200)];
        descriptionTextView.editable = NO;
        descriptionTextView.backgroundColor = [UIColor purpleColor];
        [self addSubview:descriptionTextView];

        /* Self customization */
        self.contentSize = CGSizeMake(frame.size.width, CGFloatGetAfterY(descriptionTextView.frame));
    }
    return self;
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
    CGSize newSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(view.frame.size.width, view.frame.size.height)];
    rect.size.height = newSize.height + 2*kEUEventVertBuffer;
    view.frame = rect;
}

- (void)customizeForEvent:(EUEvent *)anEvent
{
    self.event = anEvent;
    self.dateTimeLabel.text = [self.event dateString];
    self.titleLabel.text = self.event.title;
    self.descriptionTextView.text = self.event.description;
    [self autoResize:descriptionTextView];
}

+ (EUEventView *)newEventViewWithFrame:(CGRect)aFrame andEvent:(EUEvent *)anEvent
{
    EUEventView *eventView = [[EUEventView alloc] initWithFrame:aFrame];
    [eventView customizeForEvent:anEvent];
    return eventView;
}

@end
