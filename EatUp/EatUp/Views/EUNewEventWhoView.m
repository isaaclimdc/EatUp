//
//  EUNewEventWhoView.m
//  EatUp
//
//  Created by Isaac Lim on 3/16/13.
//  Copyright (c) 2013 isaacl.net. All rights reserved.
//

#import "EUNewEventWhoView.h"

@interface EUNewEventWhoView ()
{
    UITextView *inviteBox;
    UITableView *inviteesTableView;
}
@end

@implementation EUNewEventWhoView

@synthesize viewController, invitees;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        invitees = [NSMutableArray array];

        CGFloat width = frame.size.width - kEUNewEventBuffer*2;

        /* Invitees */
        UILabel *inviteLabel = [[UILabel alloc] initWithFrame:CGRectMake(kEUNewEventBuffer,
                                                                           kEUNewEventBuffer,
                                                                           width,
                                                                           kEUNewEventRowHeight)];
        inviteLabel.text = @"Invite people";
        inviteLabel.font = kEUNewEventLabelFont;
        inviteLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:inviteLabel];

        UIButton *addPeopleButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        addPeopleButton.frame = CGRectMake(kEUNewEventBuffer,
                                        CGFloatGetAfterY(inviteLabel.frame),
                                        width,
                                        kEUNewEventRowHeight);
        [addPeopleButton setTitle:@"Add Facebook friends" forState:UIControlStateNormal];
        [addPeopleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        addPeopleButton.titleLabel.font = kEUNewEventLabelFont;
        [addPeopleButton addTarget:viewController action:@selector(showNewInvitees) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:addPeopleButton];

        inviteesTableView = [[UITableView alloc] initWithFrame:CGRectMake(kEUNewEventBuffer,
                                                                           CGFloatGetAfterY(addPeopleButton.frame)+kEUNewEventBuffer,
                                                                           width,
                                                                           250.0f)];
        inviteesTableView.delegate = self;
        inviteesTableView.dataSource = self;
        [self addSubview:inviteesTableView];

        /* Finally, set content size */
        self.contentSize = CGSizeMake(frame.size.width, CGFloatGetAfterY(inviteBox.frame)+kEUNewEventBuffer);
    }
    return self;
}

- (void)didDismissWithNewUser:(EUUser *)aUser
{
    NSLog(@"Selected %@", [aUser fullName]);
    [invitees addObject:aUser];
    [inviteesTableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return invitees.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    // Configure the cell...
    EUUser *user = [invitees objectAtIndex:indexPath.row];
    cell.textLabel.text = [user fullName];
    cell.textLabel.font = kEUFontText;

    return cell;
}

#pragma mark - Table view delegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        [invitees removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EUUser *user = [invitees objectAtIndex:indexPath.row];
    NSLog(@"Tapped on %@", [user fullName]);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/* Package up data on this view and prepare for sending */
- (NSDictionary *)serialize
{
    NSMutableArray *arr = [NSMutableArray array];

    for (EUUser *invitee in invitees) {
        [arr addObject:[NSNumber numberWithDouble:invitee.uid]];   /* This will eventually be events.participants */
    }

    NSNumber *myUID = [NSNumber numberWithDouble:[[NSUserDefaults standardUserDefaults] doubleForKey:kEUUserDefaultsKeyMyUID]];
[arr addObject:myUID];
    NSDictionary *dict = @{
                           kEURequestKeyEventParticipants : arr,
                           kEURequestKeyEventHost : myUID
                           };

    return dict;
}

#pragma mark - Helper Methods

static CGFloat CGFloatGetAfterY(CGRect rect) {
    return rect.origin.y + rect.size.height;
}

@end
