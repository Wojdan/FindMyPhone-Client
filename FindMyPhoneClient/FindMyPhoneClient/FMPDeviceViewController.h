//
//  FMPDeviceViewController.h
//  FindMyPhoneClient
//
//  Created by Wojdan on 02.11.2014.
//  Copyright (c) 2014 wojdan. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * Kontroler sterujący przełączaniem innych kontrolerów dot. wybranego urządzenia
 */
@interface FMPDeviceViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

/**
 * Identifikator wybranego urządzenia
 */
@property (strong, nonatomic) NSNumber *deviceID;

/**
 * Dane wybranego urządzenia 
 */
@property (strong, nonatomic) NSDictionary *device;

/**
 * UISegmentedControl zmieniający widoki
 */
@property (strong, nonatomic) UISegmentedControl *segmentedControl;

@end
