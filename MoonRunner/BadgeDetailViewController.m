//
//  BadgeDetailViewController.m
//  MoonRunner
//
//  Created by Shannon Phu on 8/8/15.
//  Copyright (c) 2015 Shannon Phu. All rights reserved.
//

#import "BadgeDetailViewController.h"
#import "BadgeEarnedStatus.h"
#import "Badge.h"
#import "Run.h"
#import "MathController.h"
#import "BadgeController.h"

@interface BadgeDetailViewController ()
@property (nonatomic, weak) IBOutlet UIImageView *badgeImageView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *distanceLabel;
@property (nonatomic, weak) IBOutlet UILabel *earnedLabel;
@property (nonatomic, weak) IBOutlet UILabel *silverLabel;
@property (nonatomic, weak) IBOutlet UILabel *goldLabel;
@property (nonatomic, weak) IBOutlet UILabel *bestLabel;
@property (nonatomic, weak) IBOutlet UIImageView *silverImageView;
@property (nonatomic, weak) IBOutlet UIImageView *goldImageView;
@end

@implementation BadgeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI/8);
    
    self.nameLabel.text = self.status.badge.name;
    self.distanceLabel.text = [MathController stringForDistance:self.status.badge.distance];
    self.earnedLabel.text = [NSString stringWithFormat:@"Earned %@", [dateFormatter stringFromDate:self.status.earnRun.timestamp]];
    self.badgeImageView.image = [UIImage imageNamed:self.status.badge.imageName];
    
    if (self.status.silverRun) {
        self.silverImageView.transform = transform;
        self.silverImageView.hidden = NO;
        self.silverLabel.text = [NSString stringWithFormat:@"Earned on %@", [dateFormatter stringFromDate:self.status.silverRun.timestamp]];
    } else {
        self.silverImageView.hidden = YES;
        self.silverLabel.text = [NSString stringWithFormat:@"Pace < %@ for silver.", [MathController stringForAvgPaceFromDist:self.status.earnRun.distance.floatValue * silverMultiplier overTime:self.status.earnRun.duration.intValue]];
    }
    
    if (self.status.goldRun) {
        self.goldImageView.transform = transform;
        self.goldImageView.hidden = NO;
        self.goldLabel.text = [NSString stringWithFormat:@"Earned on %@", [dateFormatter stringFromDate:self.status.goldRun.timestamp]];
    } else {
        self.goldImageView.hidden = YES;
        self.goldLabel.text = [NSString stringWithFormat:@"Pace < %@ for gold.", [MathController stringForAvgPaceFromDist:self.status.earnRun.distance.floatValue * goldMultiplier overTime:self.status.earnRun.duration.intValue]];
    }
    
    self.bestLabel.text = [NSString stringWithFormat:@"Best: %@, %@", [MathController stringForAvgPaceFromDist:self.status.bestRun.distance.floatValue overTime:self.status.bestRun.duration.intValue], [dateFormatter stringFromDate:self.status.bestRun.timestamp]];;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)infoButtonPressed:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:self.status.badge.name
                                                        message:self.status.badge.info
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
