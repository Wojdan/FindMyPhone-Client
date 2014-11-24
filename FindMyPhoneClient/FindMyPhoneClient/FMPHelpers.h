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

/**
 *  Walidacja emaila
 *
 *  @param candidate Adres email, który chcemy przetestować.
 *
 *  @return YES if email is valid, otherwise it returns NO.
 */
+ (BOOL)validateEmail:(NSString *)candidate;

/**
 *  Metoda wizualizuje nieprawidłowo wypełniony formularz, poprzez zatrzęsienie nim i obramowanie na czerwono (opcjonalnie)
 *
 *  @param viewToShake Widok, który ma zostać poddany animacji trzęsienia
 *  @param showBorder włączenie lub wyłączenie obramowania po trzęsieniu
 *
 */
+ (void)shakeView:(UIView *)viewToShake showingBorder:(BOOL)showBorder;

@end
