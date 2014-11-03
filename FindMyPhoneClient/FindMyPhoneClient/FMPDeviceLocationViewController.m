//
//  FMPDeviceLocationViewController.m
//  FindMyPhoneClient
//
//  Created by Wojdan on 02.11.2014.
//  Copyright (c) 2014 wojdan. All rights reserved.
//

#import "FMPDeviceLocationViewController.h"
#import "FMPApiController.h"
#import "SVProgressHUD.h"
#import <MapKit/MapKit.h>

#define METERS_PER_MILE 1609.344

@interface FMPDeviceLocationViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableArray *locations;
@property (strong, nonatomic) NSMutableArray *annotations;

@end

@implementation FMPDeviceLocationViewController

- (void)viewDidLoad {
    NSParameterAssert(self.deviceID);
    [super viewDidLoad];

//    UIRefreshControl *refreshControl = [UIRefreshControl new];
//    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refresh locations"];
//    [refreshControl addTarget:self action:@selector(fetchLocations) forControlEvents:UIControlEventValueChanged];
//    [self.tableView addSubview:refreshControl];
//    self.refreshControl = refreshControl;

    self.locations = [NSMutableArray new];
    [self fetchLocations];


    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    self.tableView.layer.borderWidth = 0.5f;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchLocations) name:@"Refresh-Locations" object:nil];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.deviceController.segmentedControl.selectedSegmentIndex = 0;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSMutableArray *)updateAnnotations
{
    NSMutableArray *annotations = [[NSMutableArray alloc] init];

    for (NSDictionary *row in self.locations) {
        NSNumber *latitude = @([[row objectForKey:@"lat"] doubleValue]);
        NSNumber *longitude = @([[row objectForKey:@"lng"] doubleValue]);
        //Create coordinates from the latitude and longitude values
        CLLocationCoordinate2D coord;
        coord.latitude = latitude.doubleValue;
        coord.longitude = longitude.doubleValue;

        MKPointAnnotation *ann = [[MKPointAnnotation alloc] init];
        ann.coordinate = coord;

        NSDateFormatter *df = [NSDateFormatter new];
        df.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
        NSDate *date = [df dateFromString:row[@"createdAt"]];
        df.dateFormat = @"dd/MM/yyyy - HH:mm:ss";
        ann.title = [df stringFromDate:date];
        [annotations addObject:ann];
    }
    return annotations;
}

- (void)fetchLocations {

    [SVProgressHUD show];
    [FMPApiController getLocationsForDeviceWithID:self.deviceID completionHandler:^(BOOL success, NSArray *locations, NSError *error) {

        self.locations = [locations mutableCopy];
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];

        [SVProgressHUD dismiss];
    }];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.locations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];

    NSString *lat = self.locations[indexPath.row][@"lat"];
    NSString *lng = self.locations[indexPath.row][@"lng"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ / %@", lat, lng];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:20.f];

    NSDateFormatter *df = [NSDateFormatter new];
    df.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    NSDate *date = [df dateFromString:self.locations[indexPath.row][@"createdAt"]];
    df.dateFormat = @"dd/MM/yyyy - HH:mm:ss";
    cell.detailTextLabel.text = [df stringFromDate:date];
    cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:14.f];

    return cell;
}

- (void)addPinAndZoomTo:(NSDictionary*)location
{
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = [location[@"lat"] doubleValue];
    zoomLocation.longitude= [location[@"lng"] doubleValue];

    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 500, 500);
    [self.mapView setRegion:viewRegion animated:YES];
    [self.mapView regionThatFits:viewRegion];

    MKPointAnnotation *ann = [[MKPointAnnotation alloc] init];
    ann.coordinate = zoomLocation;
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotation:ann];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {


    [self addPinAndZoomTo:self.locations[indexPath.row]];

}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {

    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"ann"];
    return pin;
}

@end
