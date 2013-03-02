//
//  SideViewController.m
//  EatUp
//
//  Created by Isaac Lim on 3/2/13.
//  Copyright (c) 2013 isaacl.net. All rights reserved.
//

#import "SideViewController.h"

@interface SideViewController () {
    NSArray *entries;
}

@end

@implementation SideViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    entries = [NSArray arrayWithObjects:@"Settings", @"About", nil];
}

- (IBAction)showSettings:(id)sender
{
    [self.revealController showViewController:self.revealController.frontViewController];
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
    return entries.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SideCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSUInteger row = indexPath.row;
    cell.textLabel.text = [entries objectAtIndex:row];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = indexPath.row;
    switch (row) {
        case 0:
            [self showSettings:nil];
            break;

        default:
            break;
    }
}

@end
