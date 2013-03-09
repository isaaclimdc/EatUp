//
//  EUEvent.h
//  EatUp
//
//  Created by Isaac Lim on 3/2/13.
//  Copyright (c) 2013 isaacl.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EUUser.h"
#import "EULocation.h"

@interface EUEvent : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSDate *dateTime;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSMutableArray *participants;  /* EUUser[] */
@property (strong, nonatomic) NSMutableArray *locations;  /* EULocation[] */

+ (EUEvent *)eventFromParams:(NSDictionary *)params;

- (NSString *)dateString;
- (NSString *)participantsString;
- (NSString *)locationsString;

@end
