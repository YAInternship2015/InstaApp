//
//  IAApiClient.m
//  InstaApp
//
//  Created by Maks on 10/13/15.
//  Copyright © 2015 Maks. All rights reserved.
//

#import "IAApiClient.h"
#import <AFNetworking.h>
#import "IADataSource.h"
#import "ConstantsOfInstagramAPI.h"

static const NSString * kCountPagination = @"10";

@interface IAApiClient()

@property (nonatomic, strong) IADataSource *dataSource;

@end

@implementation IAApiClient

+ (void) loadDataNextURL:(NSString *)nextURL completeBlock:(IASuccesBlock)block failure:(IAFailureBlock)failure {
    NSString *urlString = nextURL ? nextURL : kBaseRequestURL;
    NSDictionary *params = @{@"access_token": [[NSUserDefaults standardUserDefaults] stringForKey:@"token"], @"count":kCountPagination};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:urlString
      parameters:params
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             block(responseObject);
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
             failure(error);
         }];
}

@end
