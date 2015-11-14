//
//  DetailMapViewController.h
//  ProjectRoss
//
//  Created by JoLi on 2015-11-14.
//  Copyright © 2015 Gravatron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class RideMapLocation;

@interface DetailMapViewController : UIViewController <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic, strong) NSString *mapDataItem;
@property (nonatomic, strong) RideMapLocation *mapLocationItem;

@end
