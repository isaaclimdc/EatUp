//
//  EUUser.m
//  EatUp
//
//  Created by Isaac Lim on 3/9/13.
//  Copyright (c) 2013 isaacl.net. All rights reserved.
//

#import "EUUser.h"

@implementation EUUser

@synthesize firstName, lastName, profPic, participating, friends;

+ (EUUser *)userFromParams:(NSDictionary *)params
{
    EUUser *user = [[EUUser alloc] init];
    user.firstName = [params objectForKey:@"EUUserFirstName"];
    user.lastName = [params objectForKey:@"EUUserLastName"];
    user.profPic = [NSURL URLWithString:[params objectForKey:@"EUUserProfPic"]];
    user.participating = [NSMutableArray array];
    user.friends = [NSMutableArray array];
    
    return user;
}

- (NSString *)fullName
{
    return [self.firstName stringByAppendingFormat:@" %@", self.lastName];
}

@end
