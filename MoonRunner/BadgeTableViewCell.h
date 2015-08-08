//
//  BadgeTableViewCell.h
//  MoonRunner
//
//  Created by Shannon Phu on 8/8/15.
//  Copyright (c) 2015 Shannon Phu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BadgeTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *descLabel;
@property (nonatomic, weak) IBOutlet UIImageView *badgeImageView;
@property (nonatomic, weak) IBOutlet UIImageView *silverImageView;
@property (nonatomic, weak) IBOutlet UIImageView *goldImageView;

@end
