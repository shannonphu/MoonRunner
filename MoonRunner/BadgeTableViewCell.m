//
//  BadgeTableViewCell.m
//  MoonRunner
//
//  Created by Shannon Phu on 8/8/15.
//  Copyright (c) 2015 Shannon Phu. All rights reserved.
//

#import "BadgeTableViewCell.h"

@implementation BadgeTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(10, 10, 60, 60);
}

@end
