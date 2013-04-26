//
//  EUEventCell.m
//  EatUp
//
//  Created by Isaac Lim on 3/2/13.
//  Copyright (c) 2013 isaacl.net. All rights reserved.
//

#import "EUEventCell.h"

@implementation EUEventCell

- (void)populateWithEvent:(EUEvent *)event
{
    /* Set fonts */
    self.titleLabel.font = kEUFontTitle;
    self.dateTimeLabel.font = kEUFontTextItalic;
    self.participantsLabel.font = kEUFontSubText;

    /* Put in text */
    self.titleLabel.text = event.title;
    self.dateTimeLabel.text = [event relativeDateString];
    self.participantsLabel.text = [event participantsString];

    if ([event.dateTime compare:[NSDate date]] == NSOrderedAscending) {
        self.titleLabel.textColor = [UIColor grayColor];
    }
    else if ([self isUrgent:event.dateTime]) {
        self.titleLabel.textColor = [UIColor redColor];
    }
    else {
        self.titleLabel.textColor = [UIColor blackColor];
    }

    /* Custom separator */
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(kEUEventHorzBuffer,
                                                                self.contentView.frame.size.height - 1.0,
                                                                self.frame.size.width - 2*kEUEventHorzBuffer,
                                                                1)];
    lineView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    [self.contentView addSubview:lineView];
}

- (BOOL)isUrgent:(NSDate *)aDate
{
    NSTimeInterval distanceBetweenDates = [aDate timeIntervalSinceDate:[NSDate date]];
    double secondsInAnHour = 3600;
    NSInteger hoursDiff = distanceBetweenDates / secondsInAnHour;

    return hoursDiff <= 1;
}

@end
