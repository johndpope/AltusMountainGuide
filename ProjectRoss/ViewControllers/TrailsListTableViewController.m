//
//  TrailsListTableViewController.m
//  ProjectRoss
//
//  Created by JoLi on 2015-11-15.
//  Copyright © 2015 Gravatron. All rights reserved.
//

#import "TrailsListTableViewController.h"

@interface TrailsListTableViewController ()

@end

@implementation TrailsListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.navigationBarTitle;
    
    //demo
    self.trailsDataSource = @[@"Boogieman", @"Sidewider", @"Cunt buster"];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.trailsDataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"trailDetailCell" forIndexPath:indexPath];
    cell.textLabel.text = self.trailsDataSource[indexPath.row];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ description...", self.trailsDataSource[indexPath.row]];
    
    return cell;
}


- (IBAction)closeButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
