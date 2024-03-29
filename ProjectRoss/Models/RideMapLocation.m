//
//  RideMapLocation.m
//  ProjectRoss
//
//  Created by JoLi on 2015-11-14.
//  Copyright © 2015 Gravatron. All rights reserved.
//

#import "RideMapLocation.h"

@implementation RideMapLocation

- (instancetype)initWithRideId:(NSString *)rideId
           locationCoordinates:(CLLocationCoordinate2D *)locationCoordinates
        numberOfLocationPoints:(NSNumber *)numberOflocationPoints
{
    self = [super init];
    if (self) {
        _rideId = rideId;
        _locationCoordinates = locationCoordinates;
        _numberOflocationPoints = numberOflocationPoints;
    }
    
    return self;
}


+ (instancetype)locationWithRideId:(NSString *)rideId
               locationCoordinates:(CLLocationCoordinate2D *)locationCoordinates
            numberOfLocationPoints:(NSNumber *)numberOflocationPoints
{
    return [[self alloc] initWithRideId:rideId locationCoordinates:locationCoordinates numberOfLocationPoints:numberOflocationPoints];
}

@end
