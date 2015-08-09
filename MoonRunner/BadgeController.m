//
//  BadgeController.m
//  MoonRunner
//
//  Created by Shannon Phu on 8/7/15.
//  Copyright (c) 2015 Shannon Phu. All rights reserved.
//

#import "BadgeController.h"
#import "Badge.h"
#import "Run.h"
#import "BadgeEarnedStatus.h"
#import <MapKit/MapKit.h>
#import "Location.h"
#import "MathController.h"
#import "BadgeAnnotation.h"

float const silverMultiplier = 1.05; // 5% speed increase
float const goldMultiplier = 1.10; // 10% speed increase

@interface BadgeController ()
@property (strong, nonatomic) NSArray *badges;
@end

@implementation BadgeController

+ (BadgeController *)defaultController {
    static BadgeController *controller = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        controller = [[BadgeController alloc] init];
        controller.badges = [self badgeArray];
    });
    
    return controller;
}

+ (NSArray *)badgeArray {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"badges" ofType:@"txt"];
    NSString *json = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *badgeDicts = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSMutableArray *badgeObj = [NSMutableArray array];
    
    for (NSDictionary *badgeDict in badgeDicts) {
        [badgeObj addObject:[self badgeFromDict:badgeDict]];
    }
    return badgeObj;
}

+ (Badge *)badgeFromDict:(NSDictionary *)dict {
    Badge *badge = [Badge new];
    badge.name = [dict objectForKey:@"name"];
    badge.info = [dict objectForKey:@"information"];
    badge.imageName = [dict objectForKey:@"imageName"];
    badge.distance = [[dict objectForKey:@"distance"] floatValue];
    return badge;
}

- (Badge *)bestBadgeForDistance:(float)distance {
    Badge *best = self.badges.firstObject;
    for (Badge *badge in self.badges) {
        if (distance < badge.distance) {
            break;
        }
        best = badge;
    }
    return best;
}

- (Badge *)nextBadgeForDistance:(float)distance {
    Badge *nextBadge;
    for (Badge *badge in self.badges) {
        nextBadge = badge;
        if (distance < badge.distance) {
            break;
        }
    }
    return nextBadge;
}

// compare all runs to badge requirements and replaces all badges
// best/silver/gold with new run if it meets requirements
- (NSArray *)earnStatusesForRuns:(NSArray *)runArray {
    NSMutableArray *statuses = [NSMutableArray array];
    for (Badge *badge in self.badges) {
        BadgeEarnedStatus *status = [BadgeEarnedStatus new];
        status.badge = badge;
        for (Run *run in runArray) {
            if (run.distance.floatValue > badge.distance) {
                if (!status.earnRun) {
                    status.earnRun = run;
                }
                double earnRunSpeed = status.earnRun.distance.doubleValue / status.earnRun.duration.doubleValue;
                double runSpeed = run.distance.doubleValue / run.duration.doubleValue;
                
                // deserves silver badge?
                if (!status.silverRun && runSpeed > earnRunSpeed * silverMultiplier) {
                    status.silverRun = run;
                }
                
                // deserves gold badge?
                if (!status.goldRun && runSpeed > earnRunSpeed * goldMultiplier) {
                    status.goldRun = run;
                }
                
                // best for this distance?
                if (!status.bestRun) {
                    status.bestRun = run;
                } else {
                    double oldBestSpeed = status.bestRun.distance.doubleValue / status.bestRun.duration.doubleValue;
                    // if new run is better than old best speed
                    if (runSpeed > oldBestSpeed) {
                        status.bestRun = run;
                    }
                }
            }
        }
        [statuses addObject:status];
    }
    return statuses;
}

// loop over all location points in run and adds annotation
// whenever a new distance milestone has been reached to qualify
// for a badge
- (NSArray *)annotationsForRun:(Run *)run {
    NSMutableArray *annotations = [NSMutableArray array];
    int locationIndex = 1;
    float distance = 0;
    
    for (Badge *badge in self.badges) {
        if (badge.distance > run.distance.floatValue) {
            break;
        }
        while (locationIndex < run.locations.count) {
            Location *firstLocation = [run.locations objectAtIndex:(locationIndex - 1)];
            Location *secondLocation = [run.locations objectAtIndex:locationIndex];
            
            CLLocation *firstCLLocation = [[CLLocation alloc]
                                           initWithLatitude:firstLocation.latitude.floatValue longitude:firstLocation.longitude.floatValue];
            CLLocation *secondCLLocation = [[CLLocation alloc] initWithLatitude:secondLocation.latitude.floatValue longitude:secondLocation.longitude.floatValue];
            
            distance += [secondCLLocation distanceFromLocation:firstCLLocation];
            locationIndex++;
            
            if (distance >= badge.distance) {
                BadgeAnnotation *annotation = [[BadgeAnnotation alloc] init];
                annotation.coordinate = secondCLLocation.coordinate;
                annotation.title = badge.name;
                annotation.subtitle = [MathController stringForDistance:badge.distance];
                annotation.imageName = badge.imageName;
                [annotations addObject:annotation];
                break;
            }
        }
    }
    
    return annotations;
}

@end
