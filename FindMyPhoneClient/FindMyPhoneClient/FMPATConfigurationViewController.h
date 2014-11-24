//
//  FMPATConfigurationViewController.h
//  FindMyPhoneClient
//
//  Created by Wojdan on 24.11.2014.
//  Copyright (c) 2014 wojdan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMPDeviceViewController.h"

@interface FMPATConfigurationViewController : UIViewController

@property (strong, nonatomic) NSDictionary *device;
@property (weak, nonatomic) FMPDeviceViewController *deviceController;

@end
