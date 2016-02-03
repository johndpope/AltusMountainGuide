//
//  RideMapData.m
//  ProjectRoss
//
//  Created by JoLi on 2015-11-14.
//  Copyright © 2015 Gravatron. All rights reserved.
//

#import "RideMapData.h"

@implementation RideMapData

- (instancetype)initWithLocationCoordinates:(NSArray *)locationCoordinates forRideId:(NSString *)rideId {
    self = [super init];
    if (self) {
        _rideId = rideId;
        _locationCoordinates = locationCoordinates;
    }
    
    return self;
}


+ (instancetype)initWithlocationCoordinates:(NSArray *)locationCoordinates forRideId:(NSString *)rideId {
    return [self initWithlocationCoordinates:locationCoordinates forRideId:rideId];
}


@end
