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

@synthesize eid, title, dateTime, description, participants, locations;

+ (EUEvent *)eventFromParams:(NSDictionary *)params
{
    EUEvent *event = [[EUEvent alloc] init];
    event.eid = [[params objectForKey:@"eid"] doubleValue];
    event.title = [params objectForKey:@"title"];

    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZZ"];
    event.dateTime = [df dateFromString:[params objectForKey:@"date_time"]];
    
    event.description = [params objectForKey:@"description"];

    NSMutableArray *parts = [NSMutableArray array];
    for (NSDictionary *partsDict in [params objectForKey:@"participants"]) {
        EUUser *part = [EUUser userFromParams:partsDict];
        [parts addObject:part];
    }
    event.participants = parts;

    NSMutableArray *locs = [NSMutableArray array];
    for (NSDictionary *locDict in [params objectForKey:@"locations"]) {
        EULocation *loc = [EULocation locationFromParams:locDict];
        [locs addObject:loc];
    }
    event.locations = locs;
    
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
    /* Remove myself from the string */
    double myUID = [[NSUserDefaults standardUserDefaults] doubleForKey:@"EUMyUID"];
    NSArray *tmp = [self.participants filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        EUUser *user = (EUUser *)evaluatedObject;
        return user.uid != myUID;
    }]];

    /* Empty case */
    NSInteger count = tmp.count;
    if (count == 0) {
        return @"with no others";
    }

    NSString *result = [@"with " stringByAppendingString:[tmp[0] fullName]];
    
    if (count >= 2) {
        result = [result stringByAppendingFormat:@"%@ %@", count == 2 ? @" and" : @",", [tmp[1] fullName]];
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
