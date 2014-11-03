//
//  FMPApiController.m
//  FindMyPhoneClient
//
//  Created by Wojdan on 25.10.2014.
//  Copyright (c) 2014 wojdan. All rights reserved.
//

#import "FMPApiController.h"
#import "SVProgressHUD.h"
#import "FMPDefaultsController.h"
#import "AppDelegate.h"

@implementation FMPApiController

+ (instancetype)sharedInstance {

    static FMPApiController *__sharedInstance;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{

        NSURL *baseURL = [NSURL URLWithString:API_BASE_URL];

        __sharedInstance = [[FMPApiController alloc] initWithBaseURL:baseURL];
        __sharedInstance.responseSerializer = [AFJSONResponseSerializer serializer];
        __sharedInstance.requestSerializer = [AFJSONRequestSerializer serializer];

    });
    return __sharedInstance;
}

+ (void)registerUserWithEmailAddress:(NSString *)emailAddress password:(NSString *)password completionHandler:(void (^)(BOOL, NSError *))handler {

    NSMutableDictionary *parameters = [@{
                                         @"email" : emailAddress,
                                         @"password"  : password
                                         } mutableCopy];

    [SVProgressHUD show];

    [[FMPApiController sharedInstance] POST:@"users/register" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

        [SVProgressHUD showSuccessWithStatus:@"Registration successful!"];

        NSLog(@"Registration successfull.\nResponse object:\n%@", responseObject);
        handler(YES, nil);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        [SVProgressHUD dismiss];
        [self handleError:error];
        handler(NO, error);

    }];

}

+ (void)loginWithEmailAddress:(NSString *)emailAddress password:(NSString *)password completionHandler:(void (^)(BOOL, NSError *))handler {

    NSMutableDictionary *parameters = [@{
                                         @"email" : emailAddress,
                                         @"password"  : password
                                         } mutableCopy];

    [SVProgressHUD show];
    [[FMPApiController sharedInstance] POST:@"users/login" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

        [SVProgressHUD dismiss];
        NSString *token = [operation.response allHeaderFields][@"Authorization"];
        if (token) {
            [FMPDefaultsController saveToken:token];
            [FMPApiController sharedInstance].accessToken = token;
            [[FMPApiController sharedInstance].requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];

            NSLog(@"Login successfull");
            handler(YES, nil);
        } else {
            handler(NO, nil);
        }


    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        [SVProgressHUD dismiss];
        [self handleError:error];
        handler(NO, error);
    }];
}

+ (void)addDeviceWithName:(NSString *)name description:(NSString *)description vendorID:(NSString*)vendorID completionHandler:(void (^)(BOOL, NSError *))handler {

    NSMutableDictionary *parameters = [@{
                                         @"name" : name,
                                         @"description"  : description,
                                         @"device_id" : vendorID
                                         } mutableCopy];

    [SVProgressHUD show];
    [[FMPApiController sharedInstance] POST:@"device" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

        [SVProgressHUD dismiss];
        [SVProgressHUD showSuccessWithStatus:@"Device added successfully!"];
        handler(YES,nil);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        [SVProgressHUD dismiss];
        [self handleError:error];
        handler(NO, error);
    }];
}

+ (void)updateDeviceWithID:(NSNumber*)dID name:(NSString *)name description:(NSString *)description vendorID:(NSString*)vendorID completionHandler:(void (^)(BOOL, NSError *))handler {

    NSMutableDictionary *parameters = [@{
                                         @"name" : name,
                                         @"description"  : description,
                                         @"device_id" : vendorID
                                         } mutableCopy];

    [SVProgressHUD show];
    [[FMPApiController sharedInstance] PUT:[NSString stringWithFormat:@"devices/%@",dID] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

        [SVProgressHUD dismiss];
        handler(YES,nil);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        [SVProgressHUD dismiss];
        [self handleError:error];
        handler(NO, error);
    }];
}

+ (void)getDevicesWithCompletionHandler:(void (^)(BOOL, NSArray*, NSError *))handler {

    [[FMPApiController sharedInstance] GET:@"devices" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSArray *devices = @[];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([((NSDictionary*)responseObject) objectForKey:@"devices"]) {
                devices = [((NSDictionary*)responseObject) objectForKey:@"devices"];
            }
        }

        handler(YES, devices, nil);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        [self handleError:error];
        handler(NO, nil, error);
    }];

}

+ (void)getLocationsForDeviceWithID:(NSNumber*)deviceID completionHandler:(void (^)(BOOL, NSArray*, NSError *))handler {

    NSString *path = [NSString stringWithFormat:@"devices/%@/locations", deviceID];

    [[FMPApiController sharedInstance] GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSArray *locations = @[];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([((NSDictionary*)responseObject) objectForKey:@"locations"]) {
                locations = [((NSDictionary*)responseObject) objectForKey:@"locations"];
            }
        }
        handler(YES, locations, nil);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        [self handleError:error];
        handler(NO, nil, error);
    }];
    
}

+ (void)deregisterDeviceWithID:(NSNumber*)dID completionHandler:(void (^)(BOOL, NSError *))handler {

    NSString *path;
    if (dID) {
        path = [NSString stringWithFormat:@"devices/%d", dID.integerValue];
    } else {
        [SVProgressHUD showErrorWithStatus:@"Device unregistered. Sign in again."];
        [self logout];
        return;
    }
    [[FMPApiController sharedInstance] DELETE:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

        [SVProgressHUD showSuccessWithStatus:@"Device deregistered!"];
        handler(YES, nil);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        [self handleError:error];
        handler(NO, error);
        
    }];
    
}


+ (void)logout {

    [FMPApiController sharedInstance].accessToken = nil;

    [FMPDefaultsController clearDefaults];
    [AppDelegate showLoginViewController];
}

+ (void)handleError:(NSError*)error {

    if (error.code == 403) {
        [self logout];
        [SVProgressHUD showErrorWithStatus:@"Session expired. Please sign in again."];
    } else {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }
    
}

@end
