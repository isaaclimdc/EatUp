//
//  LocationsViewController.m
//  EatUp
//
//  Created by Isaac Lim on 4/15/13.
//  Copyright (c) 2013 isaacl.net. All rights reserved.
//

#import "LocationsViewController.h"

@interface LocationsViewController ()
{
    NSUInteger selectedCell;
}
@end

@implementation LocationsViewController

@synthesize locationsArray;

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = kEUBkgColor;

    self.navigationItem.leftBarButtonItem =
    [ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"backArrow.png"]
                        selectedImage:[UIImage imageNamed:@"backArrowSelected.png"]
                               target:self
                               action:@selector(goBack:)];
}

- (IBAction)goBack:(id)sender {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.4;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:
                                 kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromLeft;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];

    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)isYelpInstalled
{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"yelp5.3:"]];
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
    return locationsArray.count == 0 ? 0 : locationsArray.count+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LocationCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Tap on a location for vote for it.\nTap on the blue buttons to see it on Yelp.";
        cell.textLabel.font = kEUFontTextItalic;
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.numberOfLines = 2;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else {
        cell.textLabel.text = [locationsArray objectAtIndex:indexPath.row-1];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.numberOfLines = 1;
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;

        if (indexPath.row == selectedCell) {
            cell.textLabel.font = kEUFontTextBold;
            UIImageView *voteImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"voted.png"]];
            voteImg.center = CGPointMake(cell.center.x+70, voteImg.center.y+5);
            voteImg.tag = 6; // MAGIC NUMBER
            [cell addSubview:voteImg];
        }
        else {
            cell.textLabel.font = kEUFontText;
            for (UIView *subv in cell.subviews) {
                if (subv.tag == 6) {
                    [subv removeFromSuperview];
                }
            }
        }

        /* Custom separator */
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(kEUEventHorzBuffer,
                                                                    cell.contentView.frame.size.height - 1.0,
                                                                    cell.frame.size.width - 2*kEUEventHorzBuffer,
                                                                    1)];
        lineView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
        [cell.contentView addSubview:lineView];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = [locationsArray objectAtIndex:indexPath.row-1];
    if ([str isEqualToString:@"Subway"]) {
        str = @"subway-pittsburgh-24";
    }
    else {
        NSMutableCharacterSet *alnum = [NSMutableCharacterSet characterSetWithCharactersInString:@" "];
        [alnum formUnionWithCharacterSet:[NSCharacterSet alphanumericCharacterSet]];
        NSCharacterSet *charactersToRemove = [alnum invertedSet];

        str = [[str componentsSeparatedByCharactersInSet:charactersToRemove] componentsJoinedByString:@""];
        str = [[str stringByReplacingOccurrencesOfString:@" " withString:@"-"] lowercaseString];
        str = [str stringByAppendingString:@"-pittsburgh"];
    }
    
    if ([self isYelpInstalled]) {
		// Call into the Yelp app
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"yelp5.3:///biz/%@", str]]];
    } else {
		// Use the Yelp touch site
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://yelp.com/biz/%@", str]]];
	}
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > 0) {
        NSUInteger oldSel = selectedCell;
        selectedCell = indexPath.row;

        [tableView deselectRowAtIndexPath:indexPath animated:YES];

        if (selectedCell != oldSel) {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            spinner.center = CGPointMake(230, cell.frame.size.height/2);
            spinner.hidesWhenStopped = YES;
            [cell addSubview:spinner];
            [spinner startAnimating];

            [self performBlock:^{
                [spinner stopAnimating];
                [spinner removeFromSuperview];
                [tableView reloadRowsAtIndexPaths:@[indexPath, [NSIndexPath indexPathForRow:oldSel inSection:0]]
                                 withRowAnimation:UITableViewRowAnimationAutomatic];
            } afterDelay:0.75];
        }
    }
}

@end
