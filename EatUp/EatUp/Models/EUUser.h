//
//  EUUser.h
//  EatUp
//
//  Created by Isaac Lim on 3/9/13.
//  Copyright (c) 2013 isaacl.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EUUser : NSObject

@property (nonatomic) double uid;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSURL *profPic;
@property (strong, nonatomic) NSMutableArray *participating;  /* Array of eid */
@property (strong, nonatomic) NSMutableArray *friends;  /* Array of uid */

+ (EUUser *)userFromParams:(NSDictionary *)params;
+ (EUUser *)userFromFBGraphUser:(FBGraphObject<FBGraphUser> *)graphUser;

- (NSString *)fullName;

- (NSDictionary *)semiSerialize;
- (NSDictionary *)serialize;

@end
