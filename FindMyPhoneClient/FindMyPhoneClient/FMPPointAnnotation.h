//
//  FMPPointAnnotation.h
//  FindMyPhoneClient
//
//  Created by Wojdan on 11.11.2014.
//  Copyright (c) 2014 wojdan. All rights reserved.
//

#import <MapKit/MapKit.h>


/**
 * Podklasa MKPointAnnotation. Wzbogaca nadklasę o potrzebne w aplikacji parametry.
 */
@interface FMPPointAnnotation : MKPointAnnotation

/**
 * Wiek pozycji w procentach.
 */
@property (nonatomic) CGFloat percentageAge;

/**
 * Numer pozycji w kolejności od najnowszej
 */
@property (nonatomic) NSUInteger index;

/**
 * Wartość decydująca czy dana pozycja jest pozycją zaznaczoną
 */
@property (nonatomic) BOOL selected;

@end
