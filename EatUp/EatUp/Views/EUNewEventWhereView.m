//
//  EUNewEventWhereView.m
//  EatUp
//
//  Created by Isaac Lim on 3/16/13.
//  Copyright (c) 2013 isaacl.net. All rights reserved.
//

#import "EUNewEventWhereView.h"

@interface EUNewEventWhereView ()
{
    UITextView *locationBox;
    UITableView *locationsTableView;
}
@end

@implementation EUNewEventWhereView

@synthesize viewController, locations;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        locations = [NSMutableArray array];

        CGFloat width = frame.size.width - kEUNewEventBuffer*2;

        /* Location */
        UILabel *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(kEUNewEventBuffer,
                                                                           kEUNewEventBuffer,
                                                                           width,
                                                                           kEUNewEventRowHeight)];
        locationLabel.text = @"Location";
        locationLabel.font = kEUNewEventLabelFont;
        locationLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:locationLabel];

        UIButton *addLocButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        addLocButton.frame = CGRectMake(kEUNewEventBuffer,
                                        CGFloatGetAfterY(locationLabel.frame),
                                        width,
                                        kEUNewEventRowHeight);
        [addLocButton setTitle:@"Add a location" forState:UIControlStateNormal];
        [addLocButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        addLocButton.titleLabel.font = kEUNewEventLabelFont;
        [addLocButton addTarget:viewController action:@selector(showNewLocation) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:addLocButton];

        locationsTableView = [[UITableView alloc] initWithFrame:CGRectMake(kEUNewEventBuffer,
                                                                           CGFloatGetAfterY(addLocButton.frame)+kEUNewEventBuffer,
                                                                           width,
                                                                           250.0f)];
        locationsTableView.delegate = self;
        locationsTableView.dataSource = self;
        [self addSubview:locationsTableView];

        /* Finally, set content size */
        self.contentSize = CGSizeMake(frame.size.width, CGFloatGetAfterY(locationBox.frame)+kEUNewEventBuffer);
    }
    return self;
}

- (void)didDismissWithNewLocation:(NSString *)aLoc
{
    NSLog(@"Selected %@", aLoc);
    [locations addObject:aLoc];
    [locationsTableView reloadData];
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
    return locations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    // Configure the cell...
    NSString *loc = [locations objectAtIndex:indexPath.row];
    cell.textLabel.text = loc;
    cell.textLabel.font = kEUFontText;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

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
        [locations removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/* Package up data on this view and prepare for sending */
- (NSDictionary *)serialize
{
    NSMutableArray *arr = [NSMutableArray array];
    for (NSString *location in locations) {
        [arr addObject:location];
    }

    NSDictionary *dict = @{kEURequestKeyEventLocations: arr};
    return dict;
}

#pragma mark - Helper Methods

static CGFloat CGFloatGetAfterY(CGRect rect) {
    return rect.origin.y + rect.size.height;
}

@end
