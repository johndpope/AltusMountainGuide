//
//  APIManager.m
//  ProjectRoss
//
//  Created by JoLi on 2015-11-14.
//  Copyright © 2015 Gravatron. All rights reserved.
//

#import "APIManager.h"
#import "RideMapLocation.h"

static NSString *const kBaseURL = @"http://staging.gravatron.com/";

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
                  withCompletionBlock:(void (^)(RideMapLocation *rideMapLocation))completionBlock
                      andFailureBlock:(void (^)(NSError *error))failureBlock
{
    NSString *ridesTestPath = @"user/robm/rides";
    NSString *ridesEncodedPath = [ridesTestPath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    [self GET:ridesEncodedPath parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *jsonRides = (NSArray *)responseObject;
        NSArray *rideIds = [self mapJsonToRideIds:jsonRides];
        
        // for test now
        NSString *testId = rideIds[1];
        
        NSString *locationsPath = [NSString stringWithFormat:@"/rides/%@/location", testId];
        NSString *locationsEncodedPath = [locationsPath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        [self GET:locationsEncodedPath parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            // NSLog(@"Points: %@", responseObject[@"points"]);
            NSArray *jsonLocations = responseObject[@"points"];
            
            RideMapLocation *finalRideMapLocation = [self mapJsonToRideMapLocation:jsonLocations forRideWithId:testId];
            completionBlock(finalRideMapLocation);
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            failureBlock(error);
        }];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
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


- (RideMapLocation *)mapJsonToRideMapLocation:(NSArray *)jsonLocations forRideWithId:(NSString *)rideId{
    CLLocationCoordinate2D finalCoordinate[jsonLocations.count];
    for (NSInteger i = 0; i < jsonLocations.count; i++) {
        NSDictionary *point = jsonLocations[i];
        NSArray *pointGeoDetail = point[@"geo"];
        double latitude= [pointGeoDetail[0] doubleValue];
        double longitude = [pointGeoDetail[1] doubleValue];
        
        CLLocationCoordinate2D pointCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
        
        finalCoordinate[i] = pointCoordinate;
        NSLog(@"Point coordinate number %lu is : lat %f | lon %f", i + 1, latitude, longitude);
    }
    
    NSLog(@"Point coordinates download finished");
    return [[RideMapLocation alloc] initWithRideId:rideId locationCoordinates:finalCoordinate numberOfLocationPoints:[NSNumber numberWithInteger:jsonLocations.count]];
}

@end
