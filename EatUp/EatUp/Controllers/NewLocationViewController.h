//
//  NewLocationViewController.h
//  EatUp
//
//  Created by Isaac Lim on 3/28/13.
//  Copyright (c) 2013 isaacl.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAuthConsumer.h"
#import "EULocation.h"
#import <CoreLocation/CoreLocation.h>

@interface NewLocationViewController : UIViewController <UITextFieldDelegate, CLLocationManagerDelegate>
{
    UITextField *searchBox;
    UITableView *resultsTable;
}

@property (strong, nonatomic) IBOutlet UITextField *searchBox;
@property (strong, nonatomic) IBOutlet UITableView *resultsTable;

@end
