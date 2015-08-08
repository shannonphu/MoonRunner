//
//  BadgeController.m
//  MoonRunner
//
//  Created by Shannon Phu on 8/7/15.
//  Copyright (c) 2015 Shannon Phu. All rights reserved.
//

#import "BadgeController.h"
#import "Badge.h"

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
    NSLog(@"%@", badgeObj);
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

@end
