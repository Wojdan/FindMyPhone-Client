//
//  FMPPointAnnotation.h
//  FindMyPhoneClient
//
//  Created by Wojdan on 11.11.2014.
//  Copyright (c) 2014 wojdan. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface FMPPointAnnotation : MKPointAnnotation

@property (nonatomic) CGFloat percentageAge;
@property (nonatomic) NSUInteger index;
@property (nonatomic) BOOL selected;

@end
