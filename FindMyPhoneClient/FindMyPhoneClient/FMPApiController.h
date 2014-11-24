//
//  FMPApiController.h
//  FindMyPhoneClient
//
//  Created by Wojdan on 25.10.2014.
//  Copyright (c) 2014 wojdan. All rights reserved.
//

#import "AFNetworking.h"

/**
 *  API URL
 */
#define API_BASE_URL @"http://find-my-phone-api.herokuapp.com/api/v1/"

/**
 * Kontroler API. Klasa odpowiedzialna za wymianę informacji z serwerem.
 *
 * @see http://find-my-phone-api.herokuapp.com/doc/ - Dokumentcja API
 */
@interface FMPApiController : AFHTTPRequestOperationManager

/**
 * Access token zalogowanego usera
 */
@property (strong, nonatomic) NSString *accessToken;

/**
 *  Singleton klasy
 */
+ (instancetype)sharedInstance;

/**
 *  Metoda wykonująca request typu POST w celu rejestracji użytkownika.
 *
 *  @param emailAddress Adres email usera
 *  @param password Hasło usera
 *  @param handler Handler przekazuje następujące parametry:
 *  <ol>
 *      <li>typu boolean sprawdzajacy czy request się powiódł</li>
 *      <li>error jeżeli wystąpił</li>
 *  </ol>
 */
+ (void)registerUserWithEmailAddress:(NSString*)emailAddress password:(NSString*)password completionHandler:(void (^)(BOOL success, NSError *error))handler;


/**
 *  Metoda wykonująca request typu POST w celu logowania użytkownika.
 *
 *  @param emailAddress Adres email usera
 *  @param password Hasło usera
 *  @param handler Handler przekazuje następujące parametry:
 *  <ol>
 *      <li>typu boolean sprawdzajacy czy request się powiódł</li>
 *      <li>error jeżeli wystąpił</li>
 *  </ol>
 */
+ (void)loginWithEmailAddress:(NSString *)emailAddress password:(NSString *)password completionHandler:(void (^)(BOOL, NSError *))handler;

/**
 *  Metoda wykonująca request typu POST w celu zarejestrowania urządzenia.
 *
 *  @param name Nazwa urządzenia
 *  @param description Opis urządzenia
 *  @param vendorID Unikalny identyfikator urządzenia
 *  @param handler Handler przekazuje następujące parametry:
 *  <ol>
 *      <li>typu boolean sprawdzajacy czy request się powiódł</li>
 *      <li>error jeżeli wystąpił</li>
 *  </ol>
 */
+ (void)addDeviceWithName:(NSString *)name description:(NSString *)description vendorID:(NSString*)vendorID completionHandler:(void (^)(BOOL, NSError *))handler;

/**
 *  Metoda wykonująca request typu PUT w celu aktualizacji opisu urządzenia.
 *
 *  @param dID identyfikator edytowanego urządzenia
 *  @param name Nazwa urządzenia
 *  @param description Opis urządzenia
 *  @param vendorID Unikalny identyfikator urządzenia
 *  @param handler Handler przekazuje następujące parametry:
 *  <ol>
 *      <li>typu boolean sprawdzajacy czy request się powiódł</li>
 *      <li>error jeżeli wystąpił</li>
 *  </ol>
 */
+ (void)updateDeviceWithID:(NSString*)dID name:(NSString *)name description:(NSString *)description vendorID:(NSString*)vendorID completionHandler:(void (^)(BOOL, NSError *))handler;

/**
 *  Metoda wykonująca request typu PUT w celu aktualizacji ustawień Anti-Thief urządzenia.
 *
 *  @param dID identyfikator edytowanego urządzenia
 *  @param email Adres email do otrzymywania raportów
 *  @param emailPeriod Częstotliwość otrzymywania raportów
 *  @param period Częstotliwość aktualizacji lokalizacji
 *  @param handler Handler przekazuje następujące parametry:
 *  <ol>
 *      <li>typu boolean sprawdzajacy czy request się powiódł</li>
 *      <li>error jeżeli wystąpił</li>
 *  </ol>
 */
+ (void)updateATSettingsForDeviceWithID:(NSInteger)dID email:(NSString*)email emailPeriod:(NSInteger)emailPeriod period:(NSInteger)period completionHandler:(void (^)(BOOL, NSError *))handler;

/**
 *  Metoda wykonująca request typu GET w celu pobrania listy urządzeń.
 *
 *  @param handler Handler przekazuje następujące parametry:
 *  <ol>
 *      <li>typu boolean sprawdzajacy czy request się powiódł</li>
 *      <li>typu NSArray - tablica zarejestrowanych na koncie urządzeń</li>
 *      <li>error jeżeli wystąpił</li>
 *  </ol>
 */
+ (void)getDevicesWithCompletionHandler:(void (^)(BOOL, NSArray*, NSError *))handler;

/**
 *  Metoda wykonująca request typu GET w celu pobrania listy lokalizacji dla danego urządzenia.
 *
 *  @param deviceID identyfikator urządzenia dla którego pobieramy lokalizacje
 *  @param handler Handler przekazuje następujące parametry:
 *  <ol>
 *      <li>typu boolean sprawdzajacy czy request się powiódł</li>
 *      <li>typu NSArray - tablica zarejestrowanych na koncie urządzeń</li>
 *      <li>error jeżeli wystąpił</li>
 *  </ol>
 */
+ (void)getLocationsForDeviceWithID:(NSNumber*)deviceID completionHandler:(void (^)(BOOL, NSArray*, NSError *))handler;


/**
 *  Metoda wykonująca request typu GET w celu pobrania ustawień dla danego urządzenia.
 *
 *  @param deviceID identyfikator urządzenia dla którego pobieramy ustawienia
 *  @param handler Handler przekazuje następujące parametry:
 *  <ol>
 *      <li>typu boolean sprawdzajacy czy request się powiódł</li>
 *      <li>typu NSDictionary - słownik przechowujący ustawienia</li>
 *      <li>error jeżeli wystąpił</li>
 *  </ol>
 */
+ (void)getSettingsForDeviceWithId:(NSInteger)deviceID withCompletionHandler:(void (^)(BOOL, NSDictionary*, NSError *))handler;


/**
 *  Metoda wykonująca request typu DELETE w celu wyrejestrowania urządzenia z konta użytkownika.
 *
 *  @param handler Handler przekazuje następujące parametry:
 *  <ol>
 *      <li>typu boolean sprawdzajacy czy request się powiódł</li>
 *      <li>error jeżeli wystąpił</li>
 *  </ol>
 */
+ (void)deregisterDeviceWithID:(NSNumber*)dID completionHandler:(void (^)(BOOL, NSError *))handler;

@end
