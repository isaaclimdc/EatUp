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

@synthesize title, dateTime, description, participants, locations;

+ (EUEvent *)eventFromParams:(NSDictionary *)params
{
    EUEvent *event = [[EUEvent alloc] init];
    event.title = [params objectForKey:@"EUEventTitle"];
    event.dateTime = [params objectForKey:@"EUEventDateTime"];
    event.description = [params objectForKey:@"EUEventDescription"];
    event.participants = [[params objectForKey:@"EUEventParticipants"] mutableCopy];
    event.locations = [[params objectForKey:@"EUEventLocations"] mutableCopy];
    
    return event;
}

- (NSString *)dateString
{
    SORelativeDateTransformer *relativeDateTransformer = [[SORelativeDateTransformer alloc] init];
    NSString *relativeDate = [relativeDateTransformer transformedValue: self.dateTime];
    return relativeDate;
}

/* Transform the participants array into a Facebook-like friendly string */
- (NSString *)participantsString
{
    NSInteger count = self.participants.count;
    
    if (count == 0) {
        return @"No participants";
    }

    NSString *result = [@"with " stringByAppendingString:[self.participants[0] fullName]];
    
    if (count >= 2) {
        result = [result stringByAppendingFormat:@"%@ %@", count == 2 ? @" and" : @",", [self.participants[1] fullName]];
    }

    if (count >= 3) {
        NSInteger numLeft = count-2;
        result = [result stringByAppendingFormat:@" and %d other%@", numLeft, numLeft > 1 ? @"s" : @""];
    }

    return result;
}

/* Transform the locations array into a Facebook-like friendly string */
- (NSString *)locationsString
{
    NSInteger count = self.locations.count;

    if (count == 0) {
        return @"No location yet";
    }
    
    EULocation *location0 = self.locations[0];
    NSString *result = [@"@ " stringByAppendingString:location0.friendlyName];

    if (count >= 2) {
        NSInteger numLeft = count-1;
        result = [result stringByAppendingFormat:@" or %d other%@", numLeft, numLeft > 1 ? @"s" : @""];
    }

    return result;
}

@end
