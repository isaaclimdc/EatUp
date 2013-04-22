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
    return locationsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LocationCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [locationsArray objectAtIndex:indexPath.row];
    cell.textLabel.font = kEUFontText;
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;

    if (indexPath.row == selectedCell) {
        UIImageView *voteImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"voted.png"]];
        voteImg.center = CGPointMake(cell.center.x+70, voteImg.center.y+5);
        voteImg.tag = 6; // MAGIC NUMBER
        [cell addSubview:voteImg];
    }
    else {
        for (UIView *subv in cell.subviews) {
            if (subv.tag == 6) {
                [subv removeFromSuperview];
            }
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = [locationsArray objectAtIndex:indexPath.row];
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger oldSel = selectedCell;
    selectedCell = indexPath.row;
    if (selectedCell != oldSel) {
        [tableView reloadRowsAtIndexPaths:@[indexPath, [NSIndexPath indexPathForRow:oldSel inSection:0]]
                         withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

@end
