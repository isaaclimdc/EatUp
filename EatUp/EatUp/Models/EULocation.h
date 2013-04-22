//
//  EULocation.h
//  EatUp
//
//  Created by Isaac Lim on 3/9/13.
//  Copyright (c) 2013 isaacl.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface EULocation : NSObject

@property (nonatomic) double lat;
@property (nonatomic) double lng;
@property (strong, nonatomic) NSString *yid;
@property (strong, nonatomic) NSString *friendlyName;
@property (strong, nonatomic) NSURL *link;
@property (nonatomic) NSInteger numVotes;

+ (EULocation *)locationFromParams:(NSDictionary *)params;
+ (EULocation *)locationFromYelpParams:(NSDictionary *)params;
- (NSComparisonResult)compareDist:(EULocation *)otherLoc
                  currentLocation:(CLLocation *)currentLoc;

- (NSDictionary *)serialize;

@end
