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
    location.lat = [[params objectForKey:@"lat"] doubleValue];
    location.lng = [[params objectForKey:@"lng"] doubleValue];
    location.friendlyName = [params objectForKey:@"friendly_name"];
    location.link = [NSURL URLWithString:[params objectForKey:@"link"]];
    location.numVotes = [[params objectForKey:@"num_votes"] integerValue];
    
    return location;
}

@end
