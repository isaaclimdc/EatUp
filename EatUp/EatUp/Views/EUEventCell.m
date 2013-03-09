//
//  EUEventCell.m
//  EatUp
//
//  Created by Isaac Lim on 3/2/13.
//  Copyright (c) 2013 isaacl.net. All rights reserved.
//

#import "EUEventCell.h"

@implementation EUEventCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)populateWithEvent:(EUEvent *)event
{
    /* Set fonts */
    self.titleLabel.font = kEUFontTitle;
    self.dateTimeLabel.font = kEUFontTextItalic;
    self.participantsLabel.font = kEUFontSubText;

    /* Put in text */
    self.titleLabel.text = event.title;
    self.dateTimeLabel.text = [event dateString];
    self.participantsLabel.text = [event participantsString];
}

@end
