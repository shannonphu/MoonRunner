//
//  MathController.h
//  MoonRunner
//
//  Created by Shannon Phu on 8/7/15.
//  Copyright (c) 2015 Shannon Phu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MathController : NSObject
+ (NSString *)stringForDistance:(float)meters;
+ (NSString *)stringForSeconds:(int)seconds usingLongFormat:(BOOL)longFormat;
+ (NSString *)stringForAvgPaceFromDist:(float)meters overTime:(int)seconds;
+ (NSArray *)colorSegmentsForLocations:(NSArray *)locations;
@end
