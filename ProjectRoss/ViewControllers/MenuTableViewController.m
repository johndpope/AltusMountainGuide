//
//  MenuTableViewController.m
//  ProjectRoss
//
//  Created by JoLi on 2015-11-15.
//  Copyright © 2015 Gravatron. All rights reserved.
//

#import "MenuTableViewController.h"
#import "NavigationViewController.h"
#import "MainMapViewController.h"
#import <REFrostedViewController/UIViewController+REFrostedViewController.h>

@interface MenuTableViewController ()

@end

@implementation MenuTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    
    // select first menu option for initial load
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}


#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NavigationViewController *navigationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"contentController"];
    
    MainMapViewController *mainMapVC = [self.storyboard instantiateViewControllerWithIdentifier:@"mainMapController"];
    navigationVC.viewControllers = @[mainMapVC];
    
    switch (indexPath.row) {
        case 0:
            mainMapVC.navigationItem.title = @"Skyiing...";
            // update map properties
            NSLog(@"Skyiing...");
            break;
            
        case 1:
            mainMapVC.navigationItem.title = @"Climbing...";
            // update map properties
            NSLog(@"Climbing...");
            break;
            
        case 2:
            
            mainMapVC.navigationItem.title = @"Hiking...";
            // update map properties
            NSLog(@"Hiking...");
            break;
            
        case 3:
            // instantiate new settings vc
            NSLog(@"Settinngs...");
            break;
    }
    
    self.frostedViewController.contentViewController = navigationVC;
    [self.frostedViewController hideMenuViewController];
}

@end
