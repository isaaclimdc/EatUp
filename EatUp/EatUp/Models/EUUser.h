//
//  EUUser.h
//  EatUp
//
//  Created by Isaac Lim on 3/9/13.
//  Copyright (c) 2013 isaacl.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EUUser : NSObject

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSURL *profPic;
@property (strong, nonatomic) NSMutableArray *participating;  /* EUEvent[] */
@property (strong, nonatomic) NSMutableArray *friends;  /* EUUser[] */

+ (EUUser *)userFromParams:(NSDictionary *)params;

- (NSString *)fullName;

@end
