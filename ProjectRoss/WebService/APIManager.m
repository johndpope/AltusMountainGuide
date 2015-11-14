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



- (void)getRidesForAreaWithPath:(NSString *)path
            withCompletionBlock:(void (^)(NSArray *ridesData))completionBlock
                andFailureBlock:(void (^)(NSError *error))failureBlock
{
    NSString *testPath = @"user/robm/rides";
    NSString *encodedPath = [testPath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    [self GET:encodedPath parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *jsonRides = (NSArray *)responseObject;
        NSArray *rideIds = [self mapJsonToRideIds:jsonRides];
        
        completionBlock(rideIds);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(error);
    }];
}


// post Array of rideIds - get array of RideMapLocation objects ?
- (void)getRideMapLocationForRideId:(NSString *)rideId
                withCompletionBlock:(void (^)(NSArray *ridesData))completionBlock
                    andFailureBlock:(void (^)(NSError *error))failureBlock
{
    NSString *path = [NSString stringWithFormat:@"/rides/%@/location", rideId];
    NSString *encodedPath = [path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    [self GET:encodedPath parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        NSLog(@"Points: %@", responseObject[@"points"]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(error);
    }];
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
        NSString *testId = rideIds[0];
        
        NSString *locationsPath = [NSString stringWithFormat:@"/rides/%@/location", testId];
        NSString *locationsEncodedPath = [locationsPath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        [self GET:locationsEncodedPath parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            // NSLog(@"Points: %@", responseObject[@"points"]);
            NSArray *locationApiData = responseObject[@"points"];
        
            CLLocationCoordinate2D finalCoordinate[locationApiData.count];
            
            for (NSInteger i = 0; i < locationApiData.count; i++) {
                NSDictionary *point = locationApiData[i];
                NSArray *pointGeoDetail = point[@"geo"];
                CGFloat longitude = [pointGeoDetail[0] doubleValue];
                CGFloat latitude = [pointGeoDetail[1] doubleValue];
                
                CLLocationCoordinate2D pointCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
                
                finalCoordinate[i] = pointCoordinate;
            }
            
            RideMapLocation *finalRideMapLocation = [[RideMapLocation alloc] initWithRideId:testId locationCoordinates:finalCoordinate numberOfLocationPoints:locationApiData.count];
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

@end
