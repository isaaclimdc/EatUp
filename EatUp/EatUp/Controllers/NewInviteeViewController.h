//
//  NewInviteeViewController.h
//  EatUp
//
//  Created by Isaac Lim on 4/1/13.
//  Copyright (c) 2013 isaacl.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EUUser.h"
#import "EUInviteeCell.h"

@protocol NewInviteeViewControllerDelegate <NSObject>

- (void)didDismissWithNewUser:(EUUser *)aUser;

@end

@interface NewInviteeViewController : UIViewController <UITextFieldDelegate>
{
    UITextField *searchBox;
    UITableView *resultsTable;
}

@property (nonatomic, weak) id <NewInviteeViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITextField *searchBox;
@property (strong, nonatomic) IBOutlet UITableView *resultsTable;

- (IBAction)searchFriends:(id)sender;

@end
