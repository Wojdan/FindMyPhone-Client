//
//  FMPDeviceConfigurationViewController.h
//  FindMyPhoneClient
//
//  Created by Wojdan on 03.11.2014.
//  Copyright (c) 2014 wojdan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMPDeviceViewController.h"

/**
 * Kontroler do konfiguracji opisu urządzenia
 */
@interface FMPDeviceConfigurationViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) NSDictionary *device;
@property (weak, nonatomic) FMPDeviceViewController *deviceController;

@end
