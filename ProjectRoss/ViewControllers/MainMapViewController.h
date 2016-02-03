//
//  MainMapViewController.h
//  ProjectRoss
//
//  Created by JoLi on 2015-11-15.
//  Copyright © 2015 Gravatron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <REFrostedViewController/REFrostedViewController.h>


@interface MainMapViewController : UIViewController 
@property (weak, nonatomic) IBOutlet UIBarButtonItem *trailsDetailToolbarButton;
@property (weak, nonatomic) IBOutlet UIView *mapPlaceholderView;
@property (weak, nonatomic) IBOutlet UIToolbar *trailsDetailToolBar;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *deleteMapButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveMapButton;

@end
