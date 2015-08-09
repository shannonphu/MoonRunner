//
//  BadgeAnnotation.h
//  MoonRunner
//
//  Created by Shannon Phu on 8/8/15.
//  Copyright (c) 2015 Shannon Phu. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface BadgeAnnotation : MKPointAnnotation <MKAnnotation>

@property (strong, nonatomic) NSString *imageName;

@end
