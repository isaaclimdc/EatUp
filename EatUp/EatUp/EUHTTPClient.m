//
//  EUHTTPClient.m
//  EatUp
//
//  Created by Isaac Lim on 4/6/13.
//  Copyright (c) 2013 isaacl.net. All rights reserved.
//

#import "EUHTTPClient.h"

@implementation EUHTTPClient

+ (EUHTTPClient *)newClientInView:(UIView *)view
{
    ILHTTPClient *client = [ILHTTPClient clientWithBaseURL:kEUBaseURL showingHUDInView:view];
    [client setParameterEncoding:AFJSONParameterEncoding];
    return (EUHTTPClient *)client;
}

@end
