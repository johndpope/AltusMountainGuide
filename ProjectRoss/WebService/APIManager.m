//
//  APIManager.m
//  ProjectRoss
//
//  Created by JoLi on 2015-11-14.
//  Copyright © 2015 Gravatron. All rights reserved.
//

#import "APIManager.h"
#import "RideMapData.h"

//static NSString *const kBaseURL = @"http://staging.gravatron.com/";
static NSString *const kBaseURL = @"http://api.gravatron.com/";

@implementation APIManager

+ (instancetype)sharedManager {
    static APIManager *_sharedManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionConfiguration.HTTPShouldSetCookies = YES;
        
        _sharedManager = [[APIManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL] sessionConfiguration:sessionConfiguration];
        _sharedManager.requestSerializer = [AFJSONRequestSerializer serializer];
        _sharedManager.responseSerializer = [AFJSONResponseSerializer serializer];
    });
    
    return _sharedManager;
}


- (void)getRideMapLocationForAreaPath:(NSString *)areaPath
                  withCompletionBlock:(void (^)(RideMapData *rideMapData))completionBlock
                      andFailureBlock:(void (^)(NSError *error))failureBlock
{
    NSString *ridesTestPath = @"user/robm/rides";
    NSString *ridesEncodedPath = [ridesTestPath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    [self GET:ridesEncodedPath parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        // location rides download Progress
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *jsonRides = (NSArray *)responseObject;
        NSArray *rideIds = [self mapJsonToRideIds:jsonRides];

        // for test now
        NSString *testId = rideIds[1];

        NSString *locationsPath = [NSString stringWithFormat:@"/rides/%@/location", testId];
        NSString *locationsEncodedPath = [locationsPath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        [self GET:locationsEncodedPath parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            // rides GPS coordinates download Progress
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSArray *jsonLocations = responseObject[@"points"];
            RideMapData *mapData = [self mapJsonToRideMapLocation:jsonLocations forRideWithId:testId];
            
            completionBlock(mapData);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failureBlock(error);
        }];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(error);
    }];
}






- (NSArray *)mapJsonToRideIds:(NSArray *)jsonRides {
    NSMutableArray *rideIds = [NSMutableArray array];
    
    for (NSDictionary *ride in jsonRides) {
        NSString *rideId = ride[@"_id"];
        [rideIds addObject:rideId];
    }
    
    return rideIds.copy;
}


- (RideMapData *)mapJsonToRideMapLocation:(NSArray *)jsonLocations forRideWithId:(NSString *)rideId {
    NSMutableArray *rideLocations = [NSMutableArray array];
    
    for (NSDictionary *point in jsonLocations) {
        NSArray *pointGeoDetail = point[@"geo"];
        CLLocationDegrees pointLatitude = [pointGeoDetail[0] doubleValue];
        CLLocationDegrees pointLongitude = [pointGeoDetail[1] doubleValue];
        CLLocation *pointGPSLocation = [[CLLocation alloc] initWithLatitude:pointLatitude longitude:pointLongitude];
        
        [rideLocations addObject:pointGPSLocation];
    }
    
    NSArray *finalRideLocations = [rideLocations copy];
    return [[RideMapData alloc] initWithLocationCoordinates:finalRideLocations forRideId:rideId];
}

@end
