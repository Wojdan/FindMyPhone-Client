//
//  DeviceCell.h
//  FindMyPhoneClient
//
//  Created by Wojdan on 01.11.2014.
//  Copyright (c) 2014 wojdan. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * Customowy UITableViewCell, wyświetlany w liście urządzeń.
 */
@interface FMPDeviceCell : UITableViewCell

/**
 * Nazwa urządzenia
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

/**
 * Opis urządzenia
 */
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

/**
 * Wewnętrzy widok (kontener) - do zmiany wyglądu komórki.
 */
@property (weak, nonatomic) IBOutlet UIView *innerContentView;

@end
