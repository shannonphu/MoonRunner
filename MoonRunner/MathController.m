//
//  MathController.m
//  MoonRunner
//
//  Created by Shannon Phu on 8/7/15.
//  Copyright (c) 2015 Shannon Phu. All rights reserved.
//

#import "MathController.h"

static bool const isMetric = YES;
static float const metersInKM = 1000;
static float const metersInMile = 1609.344;

@implementation MathController
+ (NSString *)stringForDistance:(float)meters {
    float unitDivider;
    NSString *unitName;
    if (isMetric) {
        unitName = @"km";
        unitDivider = metersInKM;
    } else {
        unitName = @"mi";
        unitDivider = metersInMile;
    }
    return [NSString stringWithFormat:@"%.2f %@", (meters / unitDivider), unitName];
}

+ (NSString *)stringForSeconds:(int)seconds usingLongFormat:(BOOL)longFormat {
    int hours = seconds / 3600;
    int remainingSeconds = seconds - hours * 3600;
    int minutes = remainingSeconds / 60;
    remainingSeconds = remainingSeconds - minutes * 60;
    
    if (longFormat) {
        if (hours > 0) {
            return [NSString stringWithFormat:@"%i hr %i min %i sec", hours, minutes, remainingSeconds];
        } else if (minutes > 0) {
            return [NSString stringWithFormat:@"%i min %i sec", minutes, remainingSeconds];
        } else if (seconds > 0) {
            return [NSString stringWithFormat:@"%i sec", remainingSeconds];
        }
    }
    else {
        if (hours > 0) {
            return [NSString stringWithFormat:@"%02i:%02i:%02i", hours, minutes, remainingSeconds];
        } else if (minutes > 0) {
            return [NSString stringWithFormat:@"%02i:%02i", minutes, remainingSeconds];
        } else if (seconds > 0) {
            return [NSString stringWithFormat:@"00:%02i", remainingSeconds];
        }
    }
    return nil;
}

+ (NSString *)stringForAvgPaceFromDist:(float)meters overTime:(int)seconds {
    if (seconds == 0 || meters == 0) {
        return @"0";
    }
    
    float avgPaceSecMeters = seconds / meters;
    
    float unitMultiplier;
    NSString *unitName;
    
    if (isMetric) {
        unitName = @"km/min";
        unitMultiplier = metersInKM;
    } else {
        unitName = @"mi/min";
        unitMultiplier = metersInMile;
    }
    
    int paceMin = (int)((avgPaceSecMeters * unitMultiplier) / 60);
    int paceSec = (int)(avgPaceSecMeters * unitMultiplier - (paceMin * 60));
    
    return [NSString stringWithFormat:@"%i:%02i %@", paceMin, paceSec, unitName];
}

@end
