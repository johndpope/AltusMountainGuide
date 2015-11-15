//
//  RideMapLocation.h
//  ProjectRoss
//
//  Created by JoLi on 2015-11-14.
//  Copyright © 2015 Gravatron. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface RideMapLocation : NSObject
@property (nonatomic, strong) NSString *rideId;
@property (nonatomic, assign) NSNumber *numberOflocationPoints;
@property (nonatomic, assign) CLLocationCoordinate2D *locationCoordinates;

- (instancetype)initWithRideId:(NSString *)rideId locationCoordinates:(CLLocationCoordinate2D *)locationCoordinates numberOfLocationPoints:(NSNumber *)numberOflocationPoints;

@end
