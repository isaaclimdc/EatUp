//
//  EUUser.m
//  EatUp
//
//  Created by Isaac Lim on 3/9/13.
//  Copyright (c) 2013 isaacl.net. All rights reserved.
//

#import "EUUser.h"

@implementation EUUser

@synthesize uid, firstName, lastName, profPic, participating, friends;

+ (EUUser *)userFromParams:(NSDictionary *)params
{
    EUUser *user = [[EUUser alloc] init];
    user.uid = [[params objectForKey:kEURequestKeyUserUID] doubleValue];
    user.firstName = [params objectForKey:kEURequestKeyUserFirstName];
    user.lastName = [params objectForKey:kEURequestKeyUserLastName];
    user.profPic = [NSURL URLWithString:[params objectForKey:kEURequestKeyUserProfPic]];

    NSMutableArray *partEvents = [NSMutableArray array];
    for (NSDictionary *partEventsDict in [params objectForKey:kEURequestKeyUserParticipating]) {
        EUEvent *partEvent = [EUEvent eventFromParams:partEventsDict];
        [partEvents addObject:partEvent];
    }
    user.participating = partEvents;

    NSMutableArray *friends = [NSMutableArray array];
    for (NSDictionary *friendsDict in [params objectForKey:kEURequestKeyUserFriends]) {
        EUUser *friend = [EUUser userFromParams:friendsDict];
        [friends addObject:friend];
    }
    user.friends = friends;

    return user;
}

+ (EUUser *)userFromFBGraphUser:(FBGraphObject<FBGraphUser> *)graphUser
{
    EUUser *user = [[EUUser alloc] init];
    user.uid = [graphUser.id doubleValue];
    user.firstName = graphUser.first_name;
    user.lastName = graphUser.last_name;
    user.profPic = [NSURL URLWithString:kEUFBUserProfPic(graphUser.id)];
    user.participating = nil;
    user.friends = nil;
    return user;
}

- (NSString *)fullName
{
    return [self.firstName stringByAppendingFormat:@" %@", self.lastName];
}

- (NSDictionary *)semiSerialize
{
    NSDictionary *dict = @{
                           kEURequestKeyUserUID : [NSNumber numberWithDouble:self.uid],
                           kEURequestKeyUserFirstName : self.firstName,
                           kEURequestKeyUserLastName : self.lastName,
                           kEURequestKeyUserProfPic : self.profPic
                           };

    return dict;
}

- (NSDictionary *)serialize
{
    NSMutableDictionary *dict = [[self semiSerialize] mutableCopy];

    /* Partially serialize the user's events */
    NSMutableArray *serialEvents = [NSMutableArray array];
    for (EUEvent *event in self.participating) {
        [serialEvents addObject:[event semiSerialize]];
    }

    /* Partially serialize the user's friends */
    NSMutableArray *serialFriends = [NSMutableArray array];
    for (EUUser *friend in self.friends) {
        [serialFriends addObject:[friend semiSerialize]];
    }

    [dict setObject:serialEvents forKey:kEURequestKeyUserParticipating];
    [dict setObject:serialFriends forKey:kEURequestKeyUserFriends];

    return dict;
}

@end
