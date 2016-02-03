//
//  RideMapData.h
//  ProjectRoss
//
//  Created by JoLi on 2015-11-14.
//  Copyright © 2015 Gravatron. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface RideMapData : NSObject
@property (nonatomic, strong) NSString *rideId;
@property (nonatomic, strong) NSArray *locationCoordinates;

- (instancetype)initWithLocationCoordinates:(NSArray *)locationCoordinates forRideId:(NSString *)rideId;
+ (instancetype)initWithlocationCoordinates:(NSArray *)locationCoordinates forRideId:(NSString *)rideId;

@end
