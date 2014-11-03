//
//  FMPDevicesViewController.m
//  FindMyPhoneClient
//
//  Created by Wojdan on 31.10.2014.
//  Copyright (c) 2014 wojdan. All rights reserved.
//
#import "AppDelegate.h"
#import "FMPDefaultsController.h"
#import "FMPDevicesViewController.h"
#import "FMPApiController.h"
#import "FMPDeviceCell.h"
#import "FMPDeviceViewController.h"

@interface FMPDevicesViewController ()

@property (strong, nonatomic) NSMutableArray *devices;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation FMPDevicesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.devices = [NSMutableArray new];

    UIRefreshControl *refreshControl = [UIRefreshControl new];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refresh devices"];
    [refreshControl addTarget:self action:@selector(fetchDevices) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    self.refreshControl = refreshControl;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchDevices) name:@"Refresh-Devices" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self fetchDevices];

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.devices count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    FMPDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceCell"];

    cell.nameLabel.text = self.devices[indexPath.row][@"name"] ? : @"";
    cell.descriptionLabel.text = self.devices[indexPath.row][@"description"] ? : @"no description";
    cell.innerContentView.layer.cornerRadius = 5.f;
    cell.innerContentView.layer.borderWidth = 0.5f;
    cell.innerContentView.layer.borderColor = [[UIColor darkGrayColor] CGColor];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell bringSubviewToFront:cell.innerContentView];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    FMPDeviceViewController *deviceController = [[UIStoryboard storyboardWithName:@"DeviceViewController" bundle:nil] instantiateInitialViewController];

    deviceController.deviceID = self.devices[indexPath.row][@"id"];
    deviceController.device = self.devices[indexPath.row];
    
    [self.navigationController pushViewController:deviceController animated:YES];

}

#pragma mark Fetching and reloading

- (void)fetchDevices {

    [FMPApiController getDevicesWithCompletionHandler:^(BOOL success, NSArray *devices, NSError *error) {

        [self.refreshControl endRefreshing];

        if (success) {
            NSMutableArray *validatedDevices = [NSMutableArray new];
            for (NSDictionary *device in devices) {
                NSMutableDictionary *validatedDevice = [NSMutableDictionary new];
                for (NSString *key in [device allKeys]) {
                    if (![device[key] isKindOfClass:[NSNull class]]) {
                        [validatedDevice setValue:device[key] forKey:key];
                    }
                }
                [validatedDevices addObject:validatedDevice];
            }

            self.devices = [[NSMutableArray alloc] initWithArray:validatedDevices];
            [self.tableView reloadData];
        }

    }];

}

#pragma mark - IBActions

- (IBAction)logoutButtonClicked:(id)sender{
    [FMPDefaultsController clearDefaults];
    [AppDelegate showLoginViewController];
}
- (IBAction)addDeviceButtonClicked:(id)sender {

    [self fetchDevices];
    //
//    UIViewController *newDeviceVC = [[UIStoryboard storyboardWithName:@"NewDeviceViewController" bundle:nil] instantiateInitialViewController];
//    [self presentViewController:newDeviceVC animated:YES completion:^{
//
//    }];

}



@end
