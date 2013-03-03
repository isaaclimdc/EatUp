//
//  EUEvent.h
//  EatUp
//
//  Created by Isaac Lim on 3/2/13.
//  Copyright (c) 2013 isaacl.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EUEvent : NSObject {
    NSString *title;
    NSDate *dateTime;
    NSMutableArray *participants;
    NSMutableArray *locations;
    NSString *description;
}

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSDate *dateTime;
@property (strong, nonatomic) NSMutableArray *participants;

+ (EUEvent *)eventWithTitle:(NSString *)aTitle time:(NSDate *)aTime participants:(NSArray *)aPart;
- (NSString *)stringDate;

@end
