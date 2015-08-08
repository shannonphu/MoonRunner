//
//  Badge.h
//  MoonRunner
//
//  Created by Shannon Phu on 8/7/15.
//  Copyright (c) 2015 Shannon Phu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Badge : NSObject
@property(strong, nonatomic) NSString *name;
@property(strong, nonatomic) NSString *imageName;
@property(strong, nonatomic) NSString *info;
@property float distance;
@end
