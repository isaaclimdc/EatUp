//
//  LocationsViewController.h
//  EatUp
//
//  Created by Isaac Lim on 4/15/13.
//  Copyright (c) 2013 isaacl.net. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationsViewController : UITableViewController
{
    NSMutableArray *locationsArray;
}

@property (strong, nonatomic) NSMutableArray *locationsArray;

@end
