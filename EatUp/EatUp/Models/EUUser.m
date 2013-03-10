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
    user.uid = [[params objectForKey:@"uid"] doubleValue];
    user.firstName = [params objectForKey:@"first_name"];
    user.lastName = [params objectForKey:@"last_name"];
    user.profPic = [NSURL URLWithString:[params objectForKey:@"prof_pic"]];

    NSMutableArray *partEvents = [NSMutableArray array];
    for (NSDictionary *partEventsDict in [params objectForKey:@"participating"]) {
        EUEvent *partEvent = [EUEvent eventFromParams:partEventsDict];
        [partEvents addObject:partEvent];
    }
    user.participating = partEvents;

    NSMutableArray *friends = [NSMutableArray array];
    for (NSDictionary *friendsDict in [params objectForKey:@"friends"]) {
        EUUser *friend = [EUUser userFromParams:friendsDict];
        [friends addObject:friend];
    }
    user.friends = friends;
    
    return user;
}

- (NSString *)fullName
{
    return [self.firstName stringByAppendingFormat:@" %@", self.lastName];
}

@end
