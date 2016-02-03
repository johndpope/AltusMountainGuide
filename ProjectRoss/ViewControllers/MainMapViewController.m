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

#import <malloc/malloc.h>
#import <objc/objc-api.h>


@interface MainMapViewController () <RMMapViewDelegate, UIAlertViewDelegate, RMTileCacheBackgroundDelegate>
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

    
    self.maxDownloadZoom = 15;
    
    RMMapboxSource *mapTileSource;
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"tileJSON"]) {
        // map not cached yet, load map  from online source
//        mapTileSource = [[RMMapboxSource alloc] initWithMapID:@"joli85.p25aidmn"];
        // mapbox.outdoors , mapbox.streets
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
        
    } else {
        // map tile source available user is/ was online
        
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
    
    [self logCacheSize];
}



#pragma mark - IBAction

- (IBAction)menuButtonTapped:(id)sender {
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    [self.frostedViewController presentMenuViewController];
}


- (IBAction)deleteMapButtonPressed:(id)sender {
    if (!self.mapView) {
        return;
    }
    
    [self deleteDownloadedMapTiles];
}


- (IBAction)saveMapButtonPressed:(id)sender {
    if (!self.mapView) {
        return;
    }
    
    NSUInteger tilesCount = [self.mapView.tileCache tileCountForSouthWest:[self.mapView latitudeLongitudeBoundingBox].southWest
                                                                northEast:[self.mapView latitudeLongitudeBoundingBox].northEast
                                                                  minZoom:self.mapView.minZoom
                                                                  maxZoom:self.maxDownloadZoom];
    
    NSLog(@"%lu tiles to download", (unsigned long)tilesCount);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Map data download"
                                                    message:@"Caching may take a long time. It is recommended that you download data via Wi-Fi."
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Download", nil];
    
    [alert show];
    
    [self logCacheSize];
}


#pragma mark - Helper

- (void)logCacheSize {
    for (RMTileCache *cache in self.mapView.tileCache.tileCaches) {
        if ([cache isMemberOfClass:[RMDatabaseCache class]]) {
//            double cacheSize = malloc_size((__bridge const void *)(cache));
            
          
            NSLog(@"Current cache size in MB: %zd", malloc_size((__bridge const void *) cache));
        }
    }
}


- (void)downloadMapTiles {
    [self.mapView removeAllCachedImages];
    
    RMMapboxSource *mapBoxSource = (RMMapboxSource *)self.mapView.tileSource;
    NSString *tileJSON = mapBoxSource.tileJSON;
    [[NSUserDefaults standardUserDefaults] setObject:tileJSON forKey:@"tileJSON"];
    
    self.mapView.tileCache.backgroundCacheDelegate = self;
    [self.mapView.tileCache beginBackgroundCacheForTileSource:self.mapView.tileSource
                                                    southWest:[self.mapView latitudeLongitudeBoundingBox].southWest
                                                    northEast:[self.mapView latitudeLongitudeBoundingBox].northEast
                                                      minZoom:self.mapView.zoom
                                                      maxZoom:self.maxDownloadZoom];
}


- (void)deleteDownloadedMapTiles {
    [self.mapView removeAllCachedImages];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"tileJSON"];
    NSLog(@"Cache cleared");
    
    [self.mapView reloadTileSource:self.mapView.tileSource];
    [self logCacheSize];
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self downloadMapTiles];
    }
}


#pragma mark - RMTileCacheBackgroundDelegate 

- (void)tileCache:(RMTileCache *)tileCache didBackgroundCacheTile:(RMTile)tile withIndex:(NSUInteger)tileIndex ofTotalTileCount:(NSUInteger)totalTileCount {
    NSLog(@"Caching tile:%lu of total tile count:%lu", (unsigned long)tileIndex, (unsigned long)totalTileCount);
}

- (void)tileCacheDidFinishBackgroundCache:(RMTileCache *)tileCache {
    NSLog(@"Map tiles download finished!!!");
    [self logCacheSize];
}


#pragma mark - RMMapViewDelegate

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


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showTrailsListView"]) {
        UINavigationController *navigationVC = (UINavigationController *)segue.destinationViewController;
        TrailsListTableViewController *trailsListVC = (TrailsListTableViewController *)navigationVC.topViewController;
        trailsListVC.navigationBarTitle = self.trailsDetailToolbarButton.title;
    }
}

@end
