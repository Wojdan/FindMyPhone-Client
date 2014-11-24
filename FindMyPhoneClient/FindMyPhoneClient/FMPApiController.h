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

+ (void)addDeviceWithName:(NSString *)name description:(NSString *)description vendorID:(NSString*)vendorID completionHandler:(void (^)(BOOL, NSError *))handler;

+ (void)updateDeviceWithID:(NSString*)dID name:(NSString *)name description:(NSString *)description vendorID:(NSString*)vendorID completionHandler:(void (^)(BOOL, NSError *))handler;

+ (void)updateATSettingsForDeviceWithID:(NSInteger)dID email:(NSString*)email emailPeriod:(NSInteger)emailPeriod period:(NSInteger)period completionHandler:(void (^)(BOOL, NSError *))handler;

+ (void)getDevicesWithCompletionHandler:(void (^)(BOOL, NSArray*, NSError *))handler;

+ (void)getLocationsForDeviceWithID:(NSNumber*)deviceID completionHandler:(void (^)(BOOL, NSArray*, NSError *))handler;

+ (void)getSettingsForDeviceWithId:(NSInteger)deviceID withCompletionHandler:(void (^)(BOOL, NSDictionary*, NSError *))handler;

+ (void)deregisterDeviceWithID:(NSNumber*)dID completionHandler:(void (^)(BOOL, NSError *))handler;

@end
