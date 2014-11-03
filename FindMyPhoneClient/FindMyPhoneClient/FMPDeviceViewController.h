//
//  FMPDeviceViewController.h
//  FindMyPhoneClient
//
//  Created by Wojdan on 02.11.2014.
//  Copyright (c) 2014 wojdan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMPDeviceViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (strong, nonatomic) NSNumber *deviceID;
@property (strong, nonatomic) NSDictionary *device;
@property (strong, nonatomic) UISegmentedControl *segmentedControl;

@end
