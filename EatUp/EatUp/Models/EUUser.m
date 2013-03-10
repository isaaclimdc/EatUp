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
    user.uid = [params objectForKey:@"uid"];
    user.firstName = [params objectForKey:@"first_name"];
    user.lastName = [params objectForKey:@"last_name"];
    user.profPic = [NSURL URLWithString:[params objectForKey:@"prof_pic"]];
    user.participating = [params objectForKey:@"participating"];
    user.friends = [params objectForKey:@"friends"];
    
    return user;
}

- (NSString *)fullName
{
    return [self.firstName stringByAppendingFormat:@" %@", self.lastName];
}

@end
