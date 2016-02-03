//
//  MainMapViewController.m
//  ProjectRoss
//
//  Created by JoLi on 2015-11-15.
//  Copyright © 2015 Gravatron. All rights reserved.
//

#import "MainMapViewController.h"
#import "RideMapData.h"
#import "APIManager.h"
#import "TrailsListTableViewController.h"
#import "Mapbox.h"


@interface MainMapViewController () <RMMapViewDelegate>
@property (nonatomic, strong) RMMapView *mapView;
@property (nonatomic, assign) NSUInteger maxDownloadZoom;

@end

@implementation MainMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.navigationItem.title) {
        self.navigationItem.title = @"Squamish Skyiing Trails";
    }
    
    // TODO:  figure out how to set map view as subview of self.mapPlaceholderView when it's frame is set to final size
//    [mapPlaceholderView layoutIfNeeded];
//    self.mapPlaceholderView .autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    RMMapView *mapView = [[RMMapView alloc] initWithFrame:self.mapPlaceholderView.bounds];
//    mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    [self.mapPlaceholderView addSubview:mapView];
    
    
    
    
//    RMMapboxSource *onlineMapSource = [[RMMapboxSource alloc] initWithMapID:@"joli85.p25aidmn"];
//    self.mapView = [[RMMapView alloc] initWithFrame:self.view.bounds andTilesource:onlineMapSource];
//    self.mapView.delegate = self;
//    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    
//    self.mapView.zoom = 10;
//    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(50.116322,-122.957359);
//    [self.mapView setCenterCoordinate:centerCoordinate animated:YES];
//    
//    [self.view addSubview:self.mapView];

    
    self.maxDownloadZoom = 22;
    
    RMMapboxSource *mapTileSource;
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"tileJSON"]) {
        // map not cached yet, load map  from online source
//        mapTileSource = [[RMMapboxSource alloc] initWithMapID:@"joli85.p25aidmn"];
        mapTileSource = [[RMMapboxSource alloc] initWithMapID:@"mapbox.run-bike-hike"];
        
    } else {
        // load cached data
        mapTileSource = [[RMMapboxSource alloc] initWithTileJSON:[[NSUserDefaults standardUserDefaults] objectForKey:@"tileJSON"]];
    }
    
    
    

    
    
    if (!mapTileSource) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Offline"
                                                        message:@"App need to be online for the first time to be able cache map data."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        
        [alert show];
    }
    
    
    self.mapView = [[RMMapView alloc] initWithFrame:self.view.bounds andTilesource:mapTileSource];
    self.mapView.delegate = self;
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.mapView setZoom:10 atCoordinate:CLLocationCoordinate2DMake(50.116322, -122.957359) animated:NO];
    self.mapView.maxZoom = self.maxDownloadZoom;
    self.mapView.tileCache = [[RMTileCache alloc] initWithExpiryPeriod:0];
    
    [self.view addSubview:self.mapView];
    
    
    
    
    [[APIManager sharedManager] getRideMapLocationForAreaPath:nil withCompletionBlock:^(RideMapData *rideMapData) {
        CLLocationCoordinate2D initialCoordinate = ((CLLocation *)rideMapData.locationCoordinates[0]).coordinate;
        RMAnnotation *rideAnnotation = [[RMAnnotation alloc] initWithMapView:self.mapView coordinate:initialCoordinate andTitle:nil];
        rideAnnotation.userInfo = rideMapData.locationCoordinates;
        [rideAnnotation setBoundingBoxFromLocations:rideMapData.locationCoordinates];
        
        [self.mapView addAnnotation:rideAnnotation];
        
    } andFailureBlock:^(NSError *error) {
        NSLog(@"%@", error);
    }];

}



- (RMMapLayer *)mapView:(RMMapView *)mapView layerForAnnotation:(RMAnnotation *)annotation {
    if (annotation.isUserLocationAnnotation) {
        return nil;
    }
    
    RMShape *ridePolyline = [[RMShape alloc] initWithView:mapView];
    ridePolyline.lineColor = [UIColor redColor];
    ridePolyline.lineWidth = 3.0;
    
    for (CLLocation *location in (NSArray *)annotation.userInfo) {
        [ridePolyline addLineToCoordinate:location.coordinate];
    }
    
    return ridePolyline;
}



- (IBAction)menuButtonTapped:(id)sender {
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    [self.frostedViewController presentMenuViewController];
}


- (IBAction)deleteMapButtonPressed:(id)sender {
    
}


- (IBAction)saveMapButtonPressed:(id)sender {
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showTrailsListView"]) {
        UINavigationController *navigationVC = (UINavigationController *)segue.destinationViewController;
        TrailsListTableViewController *trailsListVC = (TrailsListTableViewController *)navigationVC.topViewController;
        trailsListVC.navigationBarTitle = self.trailsDetailToolbarButton.title;
    }
}

@end
