//
//  FMPApiController.h
//  FindMyPhoneClient
//
//  Created by Wojdan on 25.10.2014.
//  Copyright (c) 2014 wojdan. All rights reserved.
//

#import "AFNetworking.h"

#define API_BASE_URL @"http://find-my-phone-api.herokuapp.com/api/v1/"

@interface FMPApiController : AFHTTPRequestOperationManager

@property (strong, nonatomic) NSString *accessToken;

+ (instancetype)sharedInstance;
+ (void)registerUserWithEmailAddress:(NSString*)emailAddress password:(NSString*)password completionHandler:(void (^)(BOOL success, NSError *error))handler;
+ (void)loginWithEmailAddress:(NSString *)emailAddress password:(NSString *)password completionHandler:(void (^)(BOOL, NSError *))handler;
+ (void)addDeviceWithName:(NSString *)name password:(NSString *)description vendorID:(NSString*)vendorID completionHandler:(void (^)(BOOL, NSError *))handler;

+ (void)getDevicesWithCompletionHandler:(void (^)(BOOL, NSArray*, NSError *))handler;

@end
