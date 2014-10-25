//
//  AppDelegate.m
//  FindMyPhoneClient
//
//  Created by Wojdan on 25.10.2014.
//  Copyright (c) 2014 wojdan. All rights reserved.
//

#import "AppDelegate.h"
#import "SVProgressHUD.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [self _setupAppearance];
    return YES;
}

- (void)_setupAppearance {

    [SVProgressHUD setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.75]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];

}

@end
