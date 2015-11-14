//
//  APIManager.m
//  ProjectRoss
//
//  Created by JoLi on 2015-11-14.
//  Copyright © 2015 Gravatron. All rights reserved.
//

#import "APIManager.h"

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



- (void)getRidesForAreaWithPath:(NSString *)path withCompletionBlock:(void (^)(NSArray *ridesData))completionBlock andFailureBlock:(void (^)(NSError *error))failureBlock {
    
    NSString *testPath = @"user/robm/rides";
    NSString *encodedPath = [testPath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    [self GET:encodedPath parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error...");
    }];
}

@end
