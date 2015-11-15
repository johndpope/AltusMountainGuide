//
//  MainMapViewController.h
//  ProjectRoss
//
//  Created by JoLi on 2015-11-15.
//  Copyright © 2015 Gravatron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <REFrostedViewController/REFrostedViewController.h>

@interface MainMapViewController : UIViewController <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *trailsDetailToolbarButton;

@end
