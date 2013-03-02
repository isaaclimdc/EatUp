//
//  EUEvent.m
//  EatUp
//
//  Created by Isaac Lim on 3/2/13.
//  Copyright (c) 2013 isaacl.net. All rights reserved.
//

#import "EUEvent.h"
#import "SORelativeDateTransformer.h"

@implementation EUEvent

@synthesize title, dateTime, participants;

+ (EUEvent *)eventWithTitle:(NSString *)aTitle time:(NSDate *)aTime participants:(NSArray *)aPart
{
    EUEvent *event = [[EUEvent alloc] init];
    event.title = aTitle;
    event.dateTime = aTime;
    event.participants = [aPart mutableCopy];
    return event;
}

- (NSString *)stringDate
{
    SORelativeDateTransformer *relativeDateTransformer = [[SORelativeDateTransformer alloc] init];
    NSString *relativeDate = [relativeDateTransformer transformedValue: self.dateTime];
    return relativeDate;
}

@end
