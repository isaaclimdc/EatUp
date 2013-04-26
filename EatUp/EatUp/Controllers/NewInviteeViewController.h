//
//  NewInviteeViewController.h
//  EatUp
//
//  Created by Isaac Lim on 4/1/13.
//  Copyright (c) 2013 isaacl.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "EUUser.h"
#import "EUInviteeCell.h"

@protocol NewInviteeViewControllerDelegate <NSObject>

- (void)didDismissWithNewUser:(EUUser *)aUser;

@end

@interface NewInviteeViewController : UIViewController <UITextFieldDelegate, ILAlertViewDelegate, MFMailComposeViewControllerDelegate>
{
    UITextField *searchBox;
    UITableView *resultsTable;
    NSString *eventName;
}

@property (nonatomic, weak) id <NewInviteeViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITextField *searchBox;
@property (strong, nonatomic) IBOutlet UITableView *resultsTable;
@property (strong, nonatomic) NSString *eventName;

- (IBAction)searchFriends:(id)sender;

@end
