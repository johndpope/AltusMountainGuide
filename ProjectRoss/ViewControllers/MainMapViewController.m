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
#import "TrailsListTableViewController.h"
#import "Mapbox.h"


@interface MainMapViewController () <RMMapViewDelegate>

@end

@implementation MainMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.navigationItem.title) {
        self.navigationItem.title = @"Squamish Skyiing Trails";
    }
    
 
//    [[APIManager sharedManager] getRideMapLocationForAreaPath:nil withCompletionBlock:^(RideMapLocation *rideMapLocation) {
//       // MKPolyline *polyline = [MKPolyline polylineWithCoordinates:rideMapLocation.locationCoordinates count:rideMapLocation.numberOflocationPoints.integerValue];
//        
//        // total number of points we are getting from api is 4562 but don't try to hardcode anything higher than 4460 here, otherwise you will shut down the internet :) idk why :)
//        MKPolyline *polyline = [MKPolyline polylineWithCoordinates:rideMapLocation.locationCoordinates count:4459];
//        [self.mapView setVisibleMapRect:[polyline boundingMapRect] edgePadding:UIEdgeInsetsMake(130, 130, 130, 130) animated:YES];
//        [self.mapView addOverlay:polyline level:MKOverlayLevelAboveLabels];
//        
//        
//    } andFailureBlock:^(NSError *error) {
//        NSLog(@"%@", error);
//    }];
    

    // TODO:  figure out how to set map view as subview of self.mapPlaceholderView when it's frame is set to final size
//    [mapPlaceholderView layoutIfNeeded];
//    self.mapPlaceholderView .autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    RMMapView *mapView = [[RMMapView alloc] initWithFrame:self.mapPlaceholderView.bounds];
//    mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    [self.mapPlaceholderView addSubview:mapView];
    
    
    RMMapboxSource *onlineMapSource = [[RMMapboxSource alloc] initWithMapID:@"joli85.p25aidmn"];
    RMMapView *mapView = [[RMMapView alloc] initWithFrame:self.view.bounds andTilesource:onlineMapSource];
    mapView.delegate = self;
    mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    mapView.zoom = 10;
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(50.116322,-122.957359);
    [mapView setCenterCoordinate:centerCoordinate animated:YES];
    
    [self.view addSubview:mapView];
}





- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}




//- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay {
//    if (![overlay isKindOfClass:[MKPolyline class]]) {
//        return nil;
//    }
//    
//    MKPolyline *polyline = (MKPolyline *) overlay;
//    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:polyline];
//    renderer.strokeColor = [UIColor blueColor];
//    renderer.lineWidth = 3;
//    return renderer;
//}


- (IBAction)menuButtonTapped:(id)sender {
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    [self.frostedViewController presentMenuViewController];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showTrailsListView"]) {
        UINavigationController *navigationVC = (UINavigationController *)segue.destinationViewController;
        TrailsListTableViewController *trailsListVC = (TrailsListTableViewController *)navigationVC.topViewController;
        trailsListVC.navigationBarTitle = self.trailsDetailToolbarButton.title;
    }
}

@end
