//
//  DeviceCell.h
//  FindMyPhoneClient
//
//  Created by Wojdan on 01.11.2014.
//  Copyright (c) 2014 wojdan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMPDeviceCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIView *innerContentView;

@end
