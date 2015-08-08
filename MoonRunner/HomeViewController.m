//
//  HomeViewController.m
//  MoonRunner
//
//  Created by Shannon Phu on 7/31/15.
//  Copyright (c) 2015 Shannon Phu. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"
#import "BadgeTableViewController.h"
#import "BadgeController.h"

@interface HomeViewController ()
@property (strong, nonatomic) NSArray *runArray;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    _managedObjectContext = [appDelegate managedObjectContext];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Run" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:NO];
    [fetchRequest setSortDescriptors:@[sortDesc]];
    self.runArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UIViewController *nextController = [segue destinationViewController];
    if ([nextController isKindOfClass:[NewRunViewController class]]) {
        ((NewRunViewController *) nextController).managedObjectContext = self.managedObjectContext;
    } else if ([nextController isKindOfClass:[BadgeTableViewController class]]) {
        ((BadgeTableViewController *) nextController).statusArray = [[BadgeController defaultController] earnStatusesForRuns:self.runArray];
    }
}


@end
