//
//  BadgeTableViewController.m
//  MoonRunner
//
//  Created by Shannon Phu on 8/8/15.
//  Copyright (c) 2015 Shannon Phu. All rights reserved.
//

#import "BadgeTableViewController.h"
#import "BadgeEarnedStatus.h"
#import "Badge.h"
#import "BadgeTableViewCell.h"
#import "Run.h"
#import "MathController.h"
#import "BadgeDetailViewController.h"

@interface BadgeTableViewController ()
@property (strong, nonatomic) UIColor *redColor;
@property (strong, nonatomic) UIColor *greenColor;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (assign, nonatomic) CGAffineTransform transform;
@end

@implementation BadgeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.redColor = [UIColor colorWithRed:1.0f green:20/255.0 blue:44/255.0 alpha:1.0f];
    self.greenColor = [UIColor colorWithRed:0.0f green:146/255.0 blue:78/255.0 alpha:1.0f];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    self.transform = CGAffineTransformMakeRotation(M_PI/8);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.statusArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BadgeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BadgeCell" forIndexPath:indexPath];
    
    BadgeEarnedStatus *status = [self.statusArray objectAtIndex:indexPath.row];
    cell.silverImageView.hidden = !status.silverRun;
    cell.goldImageView.hidden = !status.goldRun;
    
    if (status.earnRun) {
        cell.nameLabel.textColor = self.greenColor;
        cell.nameLabel.text = status.badge.name;
        
        cell.descLabel.textColor = self.greenColor;
        cell.descLabel.text = [NSString stringWithFormat:@"Earned: %@", [self.dateFormatter stringFromDate:status.earnRun.timestamp]];
        
        cell.imageView.image = [UIImage imageNamed:status.badge.imageName];
        cell.silverImageView.transform = self.transform;
        cell.goldImageView.transform = self.transform;
        cell.userInteractionEnabled = YES;
    } else {
        cell.nameLabel.textColor = self.redColor;
        cell.nameLabel.text = @"???";
        cell.descLabel.textColor = self.redColor;
        cell.descLabel.text = [NSString stringWithFormat:@"Run %@ to earn", [MathController stringForDistance:status.badge.distance]];
        cell.badgeImageView.image = [UIImage imageNamed:@"question_badge.png"];
        cell.userInteractionEnabled = NO;
    }
    
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[BadgeDetailViewController class]]) {
        BadgeDetailViewController *bdvc = segue.destinationViewController;
        bdvc.status = [self.statusArray objectAtIndex:[self.tableView indexPathForSelectedRow].row];
        bdvc.title = [NSString stringWithString:bdvc.status.badge.name];
    }
}


@end
