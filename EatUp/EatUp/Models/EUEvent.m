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
    event.eid = [[params objectForKey:kEURequestKeyEventEID] doubleValue];
    event.title = [params objectForKey:kEURequestKeyEventTitle];

    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = kEUDateFormat;
    NSTimeInterval intv = [[params objectForKey:kEURequestKeyEventDateTime] doubleValue] / 1000;
    event.dateTime = [NSDate dateWithTimeIntervalSince1970:intv];

    event.description = [params objectForKey:kEURequestKeyEventDescription];
    event.host = [[params objectForKey:kEURequestKeyEventHost] doubleValue];

    NSMutableArray *parts = [NSMutableArray array];
    for (NSDictionary *partsDict in [params objectForKey:kEURequestKeyEventParticipants]) {
        EUUser *part = [EUUser userFromParams:partsDict];
        [parts addObject:part];
    }
    event.participants = parts;

    NSMutableArray *locs = [NSMutableArray array];
    for (NSDictionary *locDict in [params objectForKey:kEURequestKeyEventLocations]) {
        NSString *friendlyName = [locDict objectForKey:kEURequestKeyLocationFriendlyName];
        [locs addObject:friendlyName];
    }
    event.locations = locs;

    return event;
}

+ (NSArray *)eventsFromArrParams:(NSArray *)arrParams
{
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSDictionary *params in arrParams) {
        EUEvent *event = [EUEvent eventFromParams:params];
        [array addObject:event];
    }
    
    return array;
}

- (BOOL)amIGoing
{
    for (EUUser *part in self.participants) {
        if (part.uid == [[NSUserDefaults standardUserDefaults] doubleForKey:kEUUserDefaultsKeyMyUID]) {
            return YES;
        }
    }
    
    return NO;
}

- (NSString *)relativeDateString
{
    SORelativeDateTransformer *relativeDateTransformer = [[SORelativeDateTransformer alloc] init];
    NSString *relativeDate = [relativeDateTransformer transformedValue:self.dateTime];
    return relativeDate;
}

- (NSString *)absoluteDateString
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = kEUDateFormat;
    df.dateStyle = NSDateFormatterFullStyle;

    NSString *res = [NSString stringWithFormat:@"%@ at %@", [df stringFromDate:self.dateTime], [self timeString]];
    return res;
}

- (NSString *)timeString
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:self.dateTime];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];

    return [NSString stringWithFormat:@"%2d:%02d %@", (hour%12)==0?12:(hour%12), minute, hour<12 ? @"am": @"pm"];
}

/* Transform the participants array into a Facebook-like friendly string */
- (NSString *)participantsString
{
    /* Remove myself from the string */
    double myUID = [[NSUserDefaults standardUserDefaults] doubleForKey:kEUUserDefaultsKeyMyUID];
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
- (NSAttributedString *)locationsString
{
    NSInteger count = self.locations.count;

    if (count == 0) {
        return [[NSMutableAttributedString alloc] initWithString:@"No location yet"];
    }

    NSString *location0 = self.locations[0];
    NSString *result = [@"@ " stringByAppendingString:location0];

    if (count >= 2) {
        NSInteger numLeft = count-1;
        result = [result stringByAppendingFormat:@" or %d other%@", numLeft, numLeft > 1 ? @"s" : @""];
    }

    NSMutableAttributedString *attrResult = [[NSMutableAttributedString alloc] initWithString:result];
    [attrResult addAttributes:@{
                                NSForegroundColorAttributeName : [UIColor blueColor],
                                NSUnderlineStyleAttributeName : [NSNumber numberWithInt:NSUnderlineStyleSingle]
                                }
                        range:NSMakeRange(2, attrResult.length-2)];

    return attrResult;
}

- (NSComparisonResult)compare:(EUEvent *)otherEvent
{
    return [self.dateTime compare:otherEvent.dateTime];
}

- (NSDictionary *)semiSerialize
{
    NSDictionary *dict = @{
                           kEURequestKeyEventEID : [NSNumber numberWithDouble:self.eid],
                           kEURequestKeyEventTitle : self.title,
                           kEURequestKeyEventDateTime : self.dateTime,
                           kEURequestKeyEventDescription : self.description,
                           kEURequestKeyEventHost : [NSNumber numberWithDouble:self.host]
                           };

    return dict;
}

- (NSDictionary *)serialize
{
    NSMutableDictionary *dict = [[self semiSerialize] mutableCopy];

    /* Partially serialize the participating users */
    NSMutableArray *serialParts = [NSMutableArray array];
    for (EUUser *user in self.participants) {
        [serialParts addObject:[user semiSerialize]];
    }

    /* Fully serialize the locations */
    NSMutableArray *serialLocs = [NSMutableArray array];
    for (EULocation *loc in self.locations) {
        [serialLocs addObject:[loc serialize]];
    }

    [dict setObject:serialParts forKey:kEURequestKeyEventParticipants];
    [dict setObject:serialLocs forKey:kEURequestKeyEventLocations];
    
    return dict;
}

@end
