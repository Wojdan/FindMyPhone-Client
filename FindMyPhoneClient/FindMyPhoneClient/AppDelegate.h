//
//  AppDelegate.h
//  FindMyPhoneClient
//
//  Created by Wojdan on 25.10.2014.
//  Copyright (c) 2014 wojdan. All rights reserved.
//

#import <UIKit/UIKit.h>

/**

 Delegat aplikacji
 @see http://find-my-phone-api.herokuapp.com/doc aby dowiedzieć się więcej o aplikacji

 */
@interface AppDelegate : UIResponder <UIApplicationDelegate>

/**
 * Główne okno aplikacji
 */
@property (strong, nonatomic) UIWindow *window;

/**
 *  Metoda odpowiedzialna za podmianę głównego kontrollera aplikacji.
 *
 *  @param viewController Kontroler który ma zastać użyty jako główny.
 */
+ (void)setRootViewController:(UIViewController*)viewController;

/**
 *  Metoda podmienia główny ekran na ekran logowania
 */
+ (void)showLoginViewController;

@end

