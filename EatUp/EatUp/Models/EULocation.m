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

+ (EULocation *)locationFromYelpParams:(NSDictionary *)params
{
    EULocation *location = [[EULocation alloc] init];
    NSDictionary *coords = [[params objectForKey:@"location"] objectForKey:@"coordinate"];
    location.lat = [[coords objectForKey:@"latitude"] doubleValue];
    location.lng = [[coords objectForKey:@"longitude"] doubleValue];
    location.friendlyName = [params objectForKey:@"name"];
    location.link = [NSURL URLWithString:[params objectForKey:@"url"]];
    location.numVotes = 0;

    return location;
}

- (NSComparisonResult)compareDist:(EULocation *)otherLoc
                  currentLocation:(CLLocation *)currentLoc
{
    CLLocation *loc1 = [[CLLocation alloc] initWithLatitude:self.lat longitude:self.lng];
    CLLocation *loc2 = [[CLLocation alloc] initWithLatitude:otherLoc.lat longitude:otherLoc.lng];

    CLLocationDistance dist1 = [currentLoc distanceFromLocation:loc1];
    CLLocationDistance dist2 = [currentLoc distanceFromLocation:loc2];

    if (dist1 < dist2)
        return NSOrderedAscending;
    else if (dist1 > dist2)
        return NSOrderedDescending;
    else
        return NSOrderedSame;
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
