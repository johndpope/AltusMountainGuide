//
//  RootViewController.m
//  ProjectRoss
//
//  Created by JoLi on 2015-11-15.
//  Copyright © 2015 Gravatron. All rights reserved.
//

#import "RootViewController.h"
#import <REFrostedViewController/REFrostedViewController.h>

@interface RootViewController ()

@end

@implementation RootViewController


// also need to setup storyboard ids in IB
- (void)awakeFromNib {
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentController"];
    self.menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"menuController"];
}


@end
