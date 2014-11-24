//
//  FMPDeviceViewController.m
//  FindMyPhoneClient
//
//  Created by Wojdan on 02.11.2014.
//  Copyright (c) 2014 wojdan. All rights reserved.
//

#import "FMPDeviceViewController.h"
#import "FMPDeviceLocationViewController.h"
#import "FMPDeviceConfigurationViewController.h"
#import "FMPATConfigurationViewController.h"

@interface FMPDeviceViewController ()

@property (strong, nonatomic) UIPageViewController *pageController;

@property (strong, nonatomic) FMPDeviceLocationViewController *deviceLocationVC;
@property (strong, nonatomic) FMPDeviceConfigurationViewController *deviceConfigurationVC;
@property (strong, nonatomic) FMPATConfigurationViewController *ATConfigurationVC;

@end

@implementation FMPDeviceViewController 

- (void)viewDidLoad {
    [super viewDidLoad];

    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];

    self.navigationController.navigationBar.translucent = NO;

    self.pageController.dataSource = self;
    [[self.pageController view] setFrame:[[self view] bounds]];


    self.deviceLocationVC = [[UIStoryboard storyboardWithName:@"DeviceLocationViewController" bundle:nil] instantiateInitialViewController];
    self.deviceLocationVC.deviceID = self.deviceID;
    self.deviceLocationVC.deviceController = self;
    NSArray *viewControllers = [NSArray arrayWithObject:self.deviceLocationVC];

    self.deviceConfigurationVC = [[UIStoryboard storyboardWithName:@"DeviceConfigurationViewController" bundle:nil] instantiateInitialViewController];
    self.deviceConfigurationVC.device = self.device;
    self.deviceConfigurationVC.deviceController = self;

    self.ATConfigurationVC = [[UIStoryboard storyboardWithName:@"ATConfigurationViewController" bundle:nil] instantiateInitialViewController];
    self.ATConfigurationVC.device = self.device;
    self.ATConfigurationVC.deviceController = self;

    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self addChildViewController:self.pageController];
    [[self view] addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];

    UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"Locations",@"Device", @"AT Settings"]];
    segmentControl.selectedSegmentIndex = 0;
    [segmentControl addTarget:self action:@selector(segmentControlDidChangeValue:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentControl;
    self.segmentedControl = segmentControl;

}


- (IBAction)segmentControlDidChangeValue:(id)sender {

    if ([sender selectedSegmentIndex] == 0) {
        [self.pageController setViewControllers:@[self.deviceLocationVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL finished) {

        }];
    } else if ([sender selectedSegmentIndex] == 1) {
        [self.pageController setViewControllers:@[self.deviceConfigurationVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL finished) {

        }];
    } else {
        [self.pageController setViewControllers:@[self.ATConfigurationVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL finished) {
            
        }];
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {

    if ([viewController isEqual:self.deviceLocationVC]) {
        return self.deviceConfigurationVC;
    } else if ([viewController isEqual:self.deviceConfigurationVC]) {
        return self.ATConfigurationVC;
    }

    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {

    if ([viewController isEqual:self.deviceConfigurationVC]) {
        return self.deviceLocationVC;
    } else if ([viewController isEqual:self.ATConfigurationVC]) {
        return self.deviceConfigurationVC;
    }

    return nil;
}

@end
