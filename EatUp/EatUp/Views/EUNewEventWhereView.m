//
//  EUNewEventWhereView.m
//  EatUp
//
//  Created by Isaac Lim on 3/16/13.
//  Copyright (c) 2013 isaacl.net. All rights reserved.
//

#import "EUNewEventWhereView.h"

@interface EUNewEventWhereView ()
{
    EULocation *location;
    UITextView *locationBox;
}
@end

@implementation EUNewEventWhereView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat width = frame.size.width - kEUNewEventBuffer*2;

        /* Location */
        UILabel *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(kEUNewEventBuffer,
                                                                           kEUNewEventBuffer,
                                                                           width,
                                                                           kEUNewEventRowHeight)];
        locationLabel.text = @"Location";
        locationLabel.font = kEUNewEventLabelFont;
        locationLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:locationLabel];

        locationBox = [[UITextView alloc] initWithFrame:CGRectMake(kEUNewEventBuffer,
                                                                   CGFloatGetAfterY(locationLabel.frame),
                                                                   width,
                                                                   100.0f)];
        locationBox.backgroundColor = [UIColor whiteColor];
        locationBox.font = kEUNewEventBoxFont;
        locationBox.autocapitalizationType = UITextAutocapitalizationTypeWords;
        [self addSubview:locationBox];

        /* Finally, set content size */
        self.contentSize = CGSizeMake(frame.size.width, CGFloatGetAfterY(locationBox.frame)+kEUNewEventBuffer);
    }
    return self;
}

/* Package up data on this view and prepare for sending */
- (NSDictionary *)serialize
{
    NSMutableArray *arr = [NSMutableArray array];
    [arr addObject:[location serialize]];   /* This will eventually be events.locations */
    
    NSDictionary *dict = @{kEURequestKeyEventLocations: arr};
    
    return dict;
}

#pragma mark - Helper Methods

static CGFloat CGFloatGetAfterY(CGRect rect) {
    return rect.origin.y + rect.size.height;
}

@end
