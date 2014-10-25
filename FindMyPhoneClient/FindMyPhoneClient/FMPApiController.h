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

+ (instancetype)sharedInstance;
+ (void)registerUserWithEmailAddress:(NSString*)emailAddress password:(NSString*)password completionHandler:(void (^)(BOOL success, NSError *error))handler;

@end