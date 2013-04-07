//
//  EUHTTPClient.h
//  EatUp
//
//  Created by Isaac Lim on 4/6/13.
//  Copyright (c) 2013 isaacl.net. All rights reserved.
//

#import "ILHTTPClient.h"

@interface EUHTTPClient : ILHTTPClient

+ (EUHTTPClient *)newClientInView:(UIView *)view;

@end
