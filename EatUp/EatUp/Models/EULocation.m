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
    location.lat = [[params objectForKey:@"EULocationLat"] doubleValue];
    location.lng = [[params objectForKey:@"EULocationLng"] doubleValue];
    location.friendlyName = [params objectForKey:@"EULocationFriendlyName"];
    location.link = [NSURL URLWithString:[params objectForKey:@"EULocationLink"]];
    location.numVotes = [[params objectForKey:@"EULocationNumVotes"] integerValue];
    
    return location;
}

@end
