//
//  EULocation.m
//  EatUp
//
//  Created by Isaac Lim on 3/9/13.
//  Copyright (c) 2013 isaacl.net. All rights reserved.
//

#import "EULocation.h"

@implementation EULocation

@synthesize lat, lng, friendlyName, link, numVotes;

+ (EULocation *)locationFromParams:(NSDictionary *)params
{
    EULocation *location = [[EULocation alloc] init];
    location.lat = [[params objectForKey:kEURequestKeyLocationLat] doubleValue];
    location.lng = [[params objectForKey:kEURequestKeyLocationLng] doubleValue];
    location.friendlyName = [params objectForKey:kEURequestKeyLocationFriendlyName];
    location.link = [NSURL URLWithString:[params objectForKey:kEURequestKeyLocationLink]];
    location.numVotes = [[params objectForKey:kEURequestKeyLocationNumVotes] integerValue];
    
    return location;
}

- (NSDictionary *)serialize
{    
    NSDictionary *dict = @{
                           kEURequestKeyLocationLat : [NSNumber numberWithDouble:self.lat],
                           kEURequestKeyLocationLng : [NSNumber numberWithDouble:self.lng],
                           kEURequestKeyLocationFriendlyName : self.friendlyName,
                           kEURequestKeyLocationLink : self.link,
                           kEURequestKeyLocationNumVotes : [NSNumber numberWithInt:self.numVotes]
                           };

    return dict;
}

@end
