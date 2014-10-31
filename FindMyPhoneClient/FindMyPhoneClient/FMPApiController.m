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

        [SVProgressHUD showErrorWithStatus:operation.responseObject[@"message"] ? : [error localizedDescription]];

        NSLog(@"Registration unsuccessfull!\nResponse error:\n%@", error);
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

        [SVProgressHUD showErrorWithStatus:operation.responseObject[@"message"] ? : [error localizedDescription]];

        NSLog(@"Registration unsuccessfull!\nResponse error:\n%@", error);
        handler(NO, error);
    }];
}

+ (void)addDeviceWithName:(NSString *)name password:(NSString *)description vendorID:(NSString*)vendorID completionHandler:(void (^)(BOOL, NSError *))handler {

    NSMutableDictionary *parameters = [@{
                                         @"name" : name,
                                         @"description"  : description,
                                         @"device_id" : vendorID
                                         } mutableCopy];

    [SVProgressHUD show];
    [[FMPApiController sharedInstance] POST:@"devices" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

        [SVProgressHUD showSuccessWithStatus:@"Device added successfully!"];
        handler(YES,nil);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        [SVProgressHUD showErrorWithStatus:operation.responseObject[@"message"] ? : [error localizedDescription]];

        NSLog(@"Registration unsuccessfull!\nResponse error:\n%@", error);
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

        [SVProgressHUD showErrorWithStatus:operation.responseObject[@"message"] ? : [error localizedDescription]];
        NSLog(@"Registration unsuccessfull!\nResponse error:\n%@", error);
        handler(NO, nil, error);
    }];

}

@end
