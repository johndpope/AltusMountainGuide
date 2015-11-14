//
//  DetailMapViewController.m
//  ProjectRoss
//
//  Created by JoLi on 2015-11-14.
//  Copyright © 2015 Gravatron. All rights reserved.
//

#import "DetailMapViewController.h"

@interface DetailMapViewController ()

@end

@implementation DetailMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)setMapDataItem:(id)newMapDataItem {
    if (_mapDataItem != newMapDataItem) {
        _mapDataItem = newMapDataItem;
        
        [self configureView];
    }
}


- (void)configureView {
    if (self.mapDataItem) {
        self.navigationItem.title = self.mapDataItem;
    }
}


@end
