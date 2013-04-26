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

@class NewLocationViewController;

@protocol NewLocationViewControllerDelegate <NSObject>

- (void)didDismissWithNewLocation:(NSString *)aLoc;

@end

@interface NewLocationViewController : UIViewController <UITextFieldDelegate, CLLocationManagerDelegate>
{
    UIView *searchView;
    UITextField *searchBox;
    UITableView *resultsTable;
}

@property (nonatomic, weak) id <NewLocationViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIView *searchView;
@property (strong, nonatomic) IBOutlet UITextField *searchBox;
@property (strong, nonatomic) IBOutlet UITableView *resultsTable;

- (IBAction)searchYelp:(id)sender;

@end
