//
//  DetailMapViewController.m
//  ProjectRoss
//
//  Created by JoLi on 2015-11-14.
//  Copyright © 2015 Gravatron. All rights reserved.
//

#import "DetailMapViewController.h"
#import "RideMapLocation.h"

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




- (void)configureView {
    self.navigationItem.title = self.mapDataItem;
    
    self.mapView.delegate = self;
    MKPolyline *polyline = [MKPolyline polylineWithCoordinates:self.mapLocationItem.locationCoordinates count:self.mapLocationItem.numberOflocationPoints];
    [self.mapView setVisibleMapRect:[polyline boundingMapRect] edgePadding:UIEdgeInsetsMake(30, 30, 30, 30) animated:YES];
    [self.mapView addOverlay:polyline level:MKOverlayLevelAboveLabels];
}


#pragma mark - MKMapViewDelegate

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


@end
