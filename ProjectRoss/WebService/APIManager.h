//
//  APIManager.h
//  ProjectRoss
//
//  Created by JoLi on 2015-11-14.
//  Copyright © 2015 Gravatron. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@class RideMapData;

@interface APIManager : AFHTTPSessionManager

+ (instancetype)sharedManager;
- (void)getRideMapLocationForAreaPath:(NSString *)areaPath
                  withCompletionBlock:(void (^)(RideMapData *rideMapLocation))completionBlock
                      andFailureBlock:(void (^)(NSError *error))failureBlock;

@end
