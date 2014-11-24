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

/**
 * Kontroler do wyświetlający mapę z ostatnimi zarejestrowanymi pozycjami
 */
@interface FMPDeviceLocationViewController : UIViewController <MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource>

/**
 * Identifikator wybranego urządzenia
 */
@property (strong, nonatomic) NSNumber *deviceID;

/**
 * Słaba referencja do kontrolera sterującego
 */
@property (weak, nonatomic) FMPDeviceViewController *deviceController;

@end
