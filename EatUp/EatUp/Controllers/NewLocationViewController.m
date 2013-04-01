//
//  NewLocationViewController.m
//  EatUp
//
//  Created by Isaac Lim on 3/28/13.
//  Copyright (c) 2013 isaacl.net. All rights reserved.
//

#import "NewLocationViewController.h"

@interface NewLocationViewController ()
{
    NSMutableArray *results;
    OAMutableURLRequest *request;
    OADataFetcher *fetcher;
    
    CLLocationManager *locationMgr;
    CLLocation *currentLocation;
}
@end

@implementation NewLocationViewController

@synthesize searchBox, resultsTable;

- (void)viewDidLoad
{
    [super viewDidLoad];

    searchBox.delegate = self;

    self.navigationItem.leftBarButtonItem =
    [ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"close.png"]
                        selectedImage:[UIImage imageNamed:@"closeSelected.png"]
                               target:self
                               action:@selector(performDismiss)];

    locationMgr = [[CLLocationManager alloc] init];
    locationMgr.desiredAccuracy = kCLLocationAccuracyBest;
    locationMgr.delegate = self;

    [locationMgr startUpdatingLocation];

    [self initYelpConnection];
    results = [NSMutableArray array];
    [searchBox becomeFirstResponder];
}

//- (void)viewDidDisappear:(BOOL)animated
//{
//    [locationMgr stopUpdatingLocation];
//}

- (void)initYelpConnection
{
    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:kEUYelpConsumerKey
                                                    secret:kEUYelpConsumerSecret];
    OAToken *token = [[OAToken alloc] initWithKey:kEUYelpToken
                                           secret:kEUYelpTokenSecret];

    id<OASignatureProviding, NSObject> provider = [[OAHMAC_SHA1SignatureProvider alloc] init];

    request = [[OAMutableURLRequest alloc] initWithURL:nil
                                              consumer:consumer
                                                 token:token
                                                 realm:nil
                                     signatureProvider:provider];

    fetcher = [[OADataFetcher alloc] init];
}

- (IBAction)searchYelp:(id)sender
{
    [self searchWithQuery:searchBox.text];
}

- (void)searchWithQuery:(NSString *)query
{
    if (query.length == 0) {
        [results removeAllObjects];
        [resultsTable reloadData];
        return;
    }
    
    [results removeAllObjects];
    
    CLLocationDegrees currentLat = currentLocation.coordinate.latitude;
    CLLocationDegrees currentLng = currentLocation.coordinate.longitude;
    
    NSString *unescaped = [NSString stringWithFormat:@"%@/search?term=%@&ll=%f,%f&sort=1&category_filter=food,restaurants", kEUYelpBaseURL, query, currentLat, currentLng];
    NSString *escapedString = [unescaped stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSLog(@"Connecting to %@", escapedString);

    request.URL = [NSURL URLWithString:escapedString];
    [request prepare];
    
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(requestTokenTicket:didFinishWithData:)
                  didFailSelector:@selector(requestTokenTicket:didFailWithError:)];
}

- (void)requestTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
    if (ticket.didSucceed) {
        /* Parse data into an EULocation[] */
        NSString *responseBody = [[NSString alloc] initWithData:data
                                                       encoding:NSUTF8StringEncoding];
        NSArray *buss = [[responseBody JSONValue] objectForKey:@"businesses"];
//        NSLog(@"Success!: %@", buss);

        for (NSDictionary *params in buss) {
            EULocation *bus = [EULocation locationFromYelpParams:params];
            [results addObject:bus];
        }

        /* Done. Update UI */
        NSLog(@"%d found", results.count);
        [resultsTable reloadData];
    }
}

- (void)requestTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSData *)data
{
    NSLog(@"Error!: %@", ticket.response);
}

- (void)performDismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/* Seems buggy */
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    NSMutableString *newText = [NSMutableString stringWithString:textField.text];
//    [newText insertString:string atIndex:range.location];
//
//    [self searchWithQuery:newText];
//
//    return YES;
//}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LocationCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    // Configure the cell...
    NSUInteger row = indexPath.row;
    EULocation *loc = [results objectAtIndex:row];
    cell.textLabel.text = loc.friendlyName;
    cell.detailTextLabel.text = [self howFarAwayString:loc];

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Need a NewLocationViewControllerDelegate
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    currentLocation = [locations lastObject];
    CLLocationDegrees currentLat = currentLocation.coordinate.latitude;
    CLLocationDegrees currentLng = currentLocation.coordinate.longitude;

    NSLog(@"Current location: (%f, %f)", currentLat, currentLng);

    [locationMgr stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	NSLog(@"Error with location: %@", error);
}

- (NSString *)howFarAwayString:(EULocation *)loc
{
    CLLocation *clloc = [[CLLocation alloc] initWithLatitude:loc.lat longitude:loc.lng];
    CLLocationDistance dist = [currentLocation distanceFromLocation:clloc];
    float miles = dist / 1609.344;
    return [NSString stringWithFormat:@"%.1f mi", miles];
}

@end
