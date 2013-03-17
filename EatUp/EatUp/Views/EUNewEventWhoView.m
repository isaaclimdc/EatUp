//
//  EUNewEventWhoView.m
//  EatUp
//
//  Created by Isaac Lim on 3/16/13.
//  Copyright (c) 2013 isaacl.net. All rights reserved.
//

#import "EUNewEventWhoView.h"

@interface EUNewEventWhoView ()
{
    NSMutableArray *invitees;
    
    UITextView *inviteBox;
}
@end

@implementation EUNewEventWhoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        invitees = [NSMutableArray array];
        
        CGFloat width = frame.size.width - kEUNewEventBuffer*2;

        /* Invite friends */
        UILabel *inviteLabel = [[UILabel alloc] initWithFrame:CGRectMake(kEUNewEventBuffer,
                                                                         kEUNewEventBuffer,
                                                                         width,
                                                                         kEUNewEventRowHeight)];
        inviteLabel.text = @"Invite";
        inviteLabel.font = kEUNewEventLabelFont;
        inviteLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:inviteLabel];

        inviteBox = [[UITextView alloc] initWithFrame:CGRectMake(kEUNewEventBuffer,
                                                                 CGFloatGetAfterY(inviteLabel.frame),
                                                                 width,
                                                                 100.0f)];
        inviteBox.backgroundColor = [UIColor whiteColor];
        inviteBox.font = kEUNewEventBoxFont;
        inviteBox.autocapitalizationType = UITextAutocapitalizationTypeWords;
        [self addSubview:inviteBox];

        /* Finally, set content size */
        self.contentSize = CGSizeMake(frame.size.width, CGFloatGetAfterY(inviteBox.frame)+kEUNewEventBuffer);
    }
    return self;
}

/* Package up data on this view and prepare for sending */
- (NSDictionary *)serialize
{
    NSMutableArray *arr = [NSMutableArray array];

    for (EUUser *invitee in invitees) {
        [arr addObject:[invitee semiSerialize]];   /* This will eventually be events.participants */
    }
    
    NSDictionary *dict = @{kEURequestKeyEventParticipants: arr};

    return dict;
}

#pragma mark - Helper Methods

static CGFloat CGFloatGetAfterY(CGRect rect) {
    return rect.origin.y + rect.size.height;
}

@end
