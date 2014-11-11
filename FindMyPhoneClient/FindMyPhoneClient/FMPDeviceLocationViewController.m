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
#import "FMPPointAnnotation.h"
#import <MapKit/MapKit.h>

#define METERS_PER_MILE 1609.344

@interface FMPDeviceLocationViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableArray *locations;
@property (strong, nonatomic) NSMutableArray *annotations;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuConstraint;

@property (weak, nonatomic) IBOutlet UIButton *transparentButton;
@property (nonatomic) BOOL togglingFinished;

@property (weak, nonatomic) IBOutlet UIView *menuContainerView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *toggleButton;
@end

@implementation FMPDeviceLocationViewController

- (void)viewDidLoad {
    NSParameterAssert(self.deviceID);
    [super viewDidLoad];

    UIRefreshControl *refreshControl = [UIRefreshControl new];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refresh locations"];
    [refreshControl addTarget:self action:@selector(fetchLocations) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    self.refreshControl = refreshControl;

    self.locations = [NSMutableArray new];
    [self fetchLocations];


    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.mapView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    self.mapView.layer.borderWidth = 0.5f;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleMenu) name:@"Toggle-Locations-TableView" object:nil];
    self.togglingFinished = YES;

    for (UIGestureRecognizer *gr in [self.mapView gestureRecognizers]) {
        [gr addTarget:self action:@selector(closeMenu)];
    }

    self.tableView.backgroundColor = [UIColor colorWithWhite:1.f alpha:1.f];
    self.tableView.layer.borderColor = [[UIColor colorWithRed:0.f/255.f green:144.f/255.f blue:255.f/255.f alpha:1] CGColor];
    self.tableView.layer.borderWidth = 0.5f;
    self.tableView.separatorColor = [UIColor colorWithRed:0.f/255.f green:144.f/255.f blue:255.f/255.f alpha:1];
    self.tableView.showsVerticalScrollIndicator = NO;

    self.menuContainerView.layer.cornerRadius = 7.f;
    self.menuContainerView.clipsToBounds = YES;

    self.transparentButton.hidden = YES;
    self.menuConstraint.constant = 44;
    [self.view layoutIfNeeded];
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

    for (int i = 0; i < [self.locations count]; i++) {

        NSDictionary *row = self.locations[i];
        
        NSNumber *latitude = @([[row objectForKey:@"lat"] doubleValue]);
        NSNumber *longitude = @([[row objectForKey:@"lng"] doubleValue]);
        //Create coordinates from the latitude and longitude values
        CLLocationCoordinate2D coord;
        coord.latitude = latitude.doubleValue;
        coord.longitude = longitude.doubleValue;

        FMPPointAnnotation *ann = [[FMPPointAnnotation alloc] init];
        ann.coordinate = coord;

        NSString *lat = row[@"lat"];
        NSString *lng = row[@"lng"];
        ann.title = [NSString stringWithFormat:@"%@ / %@", lat, lng];

        NSDateFormatter *df = [NSDateFormatter new];
        df.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
        NSDate *date = [df dateFromString:row[@"createdAt"]];
        df.dateFormat = @"dd/MM/yyyy - HH:mm:ss";
        ann.subtitle = [df stringFromDate:date];

        ann.percentageAge = MAX((CGFloat)(self.locations.count - i) / (CGFloat)self.locations.count, 0.3);
        ann.index = i;
        ann.selected = NO;
        [annotations addObject:ann];
    }

    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:annotations];

    return annotations;
}

- (IBAction)zoomButtonClicked:(id)sender {
    self.annotations = [self updateAnnotations];
    [self.mapView showAnnotations:self.mapView.annotations animated:YES];
    [self closeMenu];
}

- (IBAction)refreshButtonClicked:(id)sender {
    [self fetchLocations];
    [self closeMenu];
}

- (void)fetchLocations {

    [SVProgressHUD show];
    [FMPApiController getLocationsForDeviceWithID:self.deviceID completionHandler:^(BOOL success, NSArray *locations, NSError *error) {

        self.locations = [locations mutableCopy];
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];

        self.annotations = [self updateAnnotations];
        [self.mapView showAnnotations:self.mapView.annotations animated:YES];
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

    NSDateFormatter *df = [NSDateFormatter new];
    df.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    NSDate *date = [df dateFromString:self.locations[indexPath.row][@"createdAt"]];
    df.dateFormat = @"HH:mm:ss";
    cell.textLabel.text = [df stringFromDate:date];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:16.f];

    df.dateFormat = @" yyyy/MM/dd";
    cell.detailTextLabel.text = [df stringFromDate:date];
    cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:12.f];

    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];

    for (FMPPointAnnotation *ann in self.mapView.annotations) {
        if (ann.index == indexPath.row) {
            MKAnnotationView *annView = [self.mapView viewForAnnotation:ann];
            CGFloat h = cell.contentView.frame.size.height;
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(tableView.frame.size.width-h, 0, h, h)];
            imageView.contentMode = UIViewContentModeCenter;
            imageView.image = [annView.image copy];
            [cell.contentView addSubview:imageView];
        }
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

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

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    for (FMPPointAnnotation *ann in self.mapView.annotations) {
        
        if (ann.index == indexPath.row) {
            ann.selected = YES;
            [self.mapView selectAnnotation:ann animated:YES];
        }

        MKAnnotationView *annView = [self.mapView viewForAnnotation:ann];
        annView.image = [self createAnnotationImageWithPercentageAge:ann.percentageAge selected:ann.index==indexPath.row];
    }

    [self addPinAndZoomTo:self.locations[indexPath.row]];
    [tableView reloadData];
    [self closeMenu];

}

- (UIImage*)createAnnotationImageWithPercentageAge:(CGFloat)percentageAge selected:(BOOL)selected{

    CGFloat circleRadius = 24.f*percentageAge;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(circleRadius,circleRadius), NO, 0);
    UIBezierPath* p = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, circleRadius, circleRadius)];

    UIColor *pinColor = selected ? [UIColor colorWithRed:255.f/255.f green:66.f/255.f blue:0.f/255.f alpha:1] : [UIColor colorWithRed:0.f/255.f green:144.f/255.f blue:255.f/255.f alpha:1];
    [pinColor setFill];

    [p fill];

    UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    if (selected) {
        return im;
    }

    UIGraphicsBeginImageContextWithOptions(im.size, NO, 0.0f);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, im.size.width, im.size.height);
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    CGContextSetAlpha(ctx, percentageAge);
    CGContextDrawImage(ctx, area, im.CGImage);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return newImage;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {

    FMPPointAnnotation *ann = annotation;

    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:ann
                                                                     reuseIdentifier:@"identifier"];
    annotationView.canShowCallout = YES;
    annotationView.image = [self createAnnotationImageWithPercentageAge:ann.percentageAge selected:ann.selected];

    return annotationView;

}

- (void)toggleMenu {

    if (!self.togglingFinished) {
        return;
    }

    self.togglingFinished = NO;

    self.menuConstraint.constant = self.menuConstraint.constant == 44 ? 3./4. * self.view.frame.size.height :44;

    self.transparentButton.hidden = self.menuConstraint.constant == 44;

    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:self.transparentButton.hidden ? UIBarButtonSystemItemBookmarks : UIBarButtonSystemItemCancel target:self action:@selector(toggleMenu)];

    [self.toggleButton setBackgroundImage:button.image forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];

    [UIView animateWithDuration:0.2f animations:^{
        [self.view layoutSubviews];
    } completion:^(BOOL finished) {
        if (finished) {
            self.togglingFinished = YES;
        }
    }];
}

- (void)closeMenu {

    self.menuConstraint.constant = 44;
    self.transparentButton.hidden = YES;

    [UIView animateWithDuration:0.2f animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            self.togglingFinished = YES;
        }
    }];
}
- (IBAction)toggleButtonClicked:(id)sender {
    [self toggleMenu];
}

- (IBAction)transparentButtonClicked:(id)sender {
    [self closeMenu];
}
@end
