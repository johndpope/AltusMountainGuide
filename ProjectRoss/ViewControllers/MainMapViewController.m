//
//  MainMapViewController.m
//  ProjectRoss
//
//  Created by JoLi on 2015-11-15.
//  Copyright © 2015 Gravatron. All rights reserved.
//

#import "MainMapViewController.h"
#import "RideMapLocation.h"
#import "APIManager.h"

@interface MainMapViewController ()

@end

@implementation MainMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate = self;
 
    [[APIManager sharedManager] getRideMapLocationForAreaPath:nil withCompletionBlock:^(RideMapLocation *rideMapLocation) {
       // MKPolyline *polyline = [MKPolyline polylineWithCoordinates:rideMapLocation.locationCoordinates count:rideMapLocation.numberOflocationPoints.integerValue];
        
        // total number of points we are getting from api is 4562 but don't try to hardcode anything higher than 4460 here, otherwise you will shut down the internet :) idk why :)
        MKPolyline *polyline = [MKPolyline polylineWithCoordinates:rideMapLocation.locationCoordinates count:4459];
        [self.mapView setVisibleMapRect:[polyline boundingMapRect] edgePadding:UIEdgeInsetsMake(130, 130, 130, 130) animated:YES];
        [self.mapView addOverlay:polyline level:MKOverlayLevelAboveLabels];
        
        
    } andFailureBlock:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay {
    if (![overlay isKindOfClass:[MKPolyline class]]) {
        return nil;
    }
    
    MKPolyline *polyline = (MKPolyline *) overlay;
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:polyline];
    renderer.strokeColor = [UIColor blueColor];
    renderer.lineWidth = 3;
    return renderer;
}


- (IBAction)menuButtonTapped:(id)sender {
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    [self.frostedViewController presentMenuViewController];
}


@end
