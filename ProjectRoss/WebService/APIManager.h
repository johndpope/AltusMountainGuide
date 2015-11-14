//
//  APIManager.h
//  ProjectRoss
//
//  Created by JoLi on 2015-11-14.
//  Copyright © 2015 Gravatron. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface APIManager : AFHTTPSessionManager

+ (instancetype)sharedManager;

- (void)getRidesForAreaWithPath:(NSString *)path
            withCompletionBlock:(void (^)(NSArray *ridesData))completionBlock
                andFailureBlock:(void (^)(NSError *error))failureBlock;


- (void)getRideMapLocationForRideId:(NSString *)rideId
                withCompletionBlock:(void (^)(NSArray *ridesData))completionBlock
                    andFailureBlock:(void (^)(NSError *error))failureBlock;

@end
