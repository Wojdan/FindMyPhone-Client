//
//  FMPDeviceLocationViewController.h
//  FindMyPhoneClient
//
//  Created by Wojdan on 02.11.2014.
//  Copyright (c) 2014 wojdan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "FMPDeviceViewController.h"

@interface FMPDeviceLocationViewController : UIViewController <MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSNumber *deviceID;
@property (weak, nonatomic) FMPDeviceViewController *deviceController;

@end
