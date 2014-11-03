//
//  FMPHelpers.h
//  FindMyPhoneClient
//
//  Created by Wojdan on 26.10.2014.
//  Copyright (c) 2014 wojdan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define FMP_GREEN_COLOR [UIColor colorWithRed:86.f/255.f green:167.f/255.f blue:62.f/255.f alpha:1]

@interface FMPHelpers : NSObject

+ (BOOL)validateEmail:(NSString *)candidate;
+ (void)shakeView:(UIView *)viewToShake showingBorder:(BOOL)showBorder;

@end
