//
//  MathController.m
//  MoonRunner
//
//  Created by Shannon Phu on 8/7/15.
//  Copyright (c) 2015 Shannon Phu. All rights reserved.
//

#import "MathController.h"
#import "MultiColorPolyline.h"
#import "Location.h"

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

// return array of speed between every 2 consecutive location points
+ (NSArray *)colorSegmentsForLocations:(NSArray *)locations {
    NSMutableArray *speeds = [NSMutableArray array];
    double slowestSpeed = DBL_MAX;
    double fastestSpeed = 0.0;
    
    for (int i = 1; i < locations.count; i++) {
        Location *firstLocation = [locations objectAtIndex:(i - 1)];
        Location *secondLocation = [locations objectAtIndex:i];
        
        // convert Location objects to CLLocation
        CLLocation *firstCLLocation = [[CLLocation alloc] initWithLatitude:firstLocation.latitude.doubleValue longitude:firstLocation.longitude.doubleValue];
        CLLocation *secondCLLocation = [[CLLocation alloc] initWithLatitude:secondLocation.latitude.doubleValue longitude:secondLocation.longitude.doubleValue];
        
        // calculate speed using position change over time change
        double distance = [secondCLLocation distanceFromLocation:firstCLLocation];
        double time = [secondLocation.timestamp timeIntervalSinceDate:firstLocation.timestamp];
        double speed = distance / time;
        
        slowestSpeed = speed < slowestSpeed ? speed : slowestSpeed;
        fastestSpeed = speed > fastestSpeed ? speed : fastestSpeed;
        
        [speeds addObject:@(speed)];
    }
    
    double meanSpeed = (slowestSpeed + fastestSpeed)/2;
    
    // RGB for red (slowest)
    CGFloat r_red = 1.0f;
    CGFloat r_green = 20/255.0f;
    CGFloat r_blue = 44/255.0f;
    
    // RGB for yellow (middle)
    CGFloat y_red = 1.0f;
    CGFloat y_green = 215/255.0f;
    CGFloat y_blue = 0.0f;
    
    // RGB for green (fastest)
    CGFloat g_red = 0.0f;
    CGFloat g_green = 146/255.0f;
    CGFloat g_blue = 78/255.0f;
    
    NSMutableArray *colorSegments = [NSMutableArray array];
    for (int i = 1; i < locations.count; i++) {
        Location *firstLocation = [locations objectAtIndex:(i - 1)];
        Location *secondLocation = [locations objectAtIndex:i];
        
        CLLocationCoordinate2D coord[2];
        coord[0].latitude = firstLocation.latitude.floatValue;
        coord[0].longitude = firstLocation.longitude.floatValue;
        coord[1].latitude = secondLocation.latitude.floatValue;
        coord[1].longitude = secondLocation.longitude.floatValue;
        
        double speed = [[speeds objectAtIndex:(i - 1)] doubleValue];
        UIColor *color = [UIColor blackColor];
        
        CGFloat red;
        CGFloat green;
        CGFloat blue;
        
        if (speed < meanSpeed) {
            double ratio = (speed - slowestSpeed) / (meanSpeed - slowestSpeed);
            red = r_red + ratio * (y_red - r_red);
            green = r_green + ratio * (y_green - r_green);
            blue = r_blue + ratio * (y_blue - r_blue);
        } else {
            double ratio = (speed - meanSpeed) / (fastestSpeed - meanSpeed);
            red = y_red + ratio * (g_red - y_red);
            green = y_green + ratio * (g_green - y_green);
            blue = y_blue + ratio * (g_blue - y_blue);
        }
        color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
        
        MultiColorPolyline *segment = [MultiColorPolyline polylineWithCoordinates:coord count:2];
        segment.color = color;
        
        [colorSegments addObject:segment];
    }
    
    return colorSegments;
}

@end
