//
//  FMPATConfigurationViewController.h
//  FindMyPhoneClient
//
//  Created by Wojdan on 24.11.2014.
//  Copyright (c) 2014 wojdan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMPDeviceViewController.h"

/**
 * Kontroler do konfiguracji ustawień Anti-Thief
 */
@interface FMPATConfigurationViewController : UIViewController

/**
 * Dane wybranego urządzenia
 */
@property (strong, nonatomic) NSDictionary *device;

/**
 * Słaba referencja do kontrolera sterującego
 */
@property (weak, nonatomic) FMPDeviceViewController *deviceController;

@end
