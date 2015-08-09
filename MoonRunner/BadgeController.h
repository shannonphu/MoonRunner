//
//  BadgeController.h
//  MoonRunner
//
//  Created by Shannon Phu on 8/7/15.
//  Copyright (c) 2015 Shannon Phu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Badge;
@class Run;

extern float const silverMultiplier;
extern float const goldMultiplier;

@interface BadgeController : NSObject
+ (BadgeController *)defaultController;
- (NSArray *)earnStatusesForRuns:(NSArray *)runArray;
- (Badge *)bestBadgeForDistance:(float)distance;
- (Badge *)nextBadgeForDistance:(float)distance;
- (NSArray *)annotationsForRun:(Run *)run;
@end
