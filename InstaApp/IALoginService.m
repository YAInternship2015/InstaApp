//
//  IALogin.m
//  InstaApp
//
//  Created by Maks on 10/18/15.
//  Copyright © 2015 Maks. All rights reserved.
//

#import "IALoginService.h"
#import "IALoader.h"
#import "IAApiClient.h"
#import "ConstantsOfInstagramAPI.h"
#import <AFNetworking.h>

@implementation IALoginService

+ (void)startLogin {
    NSString *fullAuthUrlString = [[NSString alloc]
                                   initWithFormat:@"%@?client_id=%@&redirect_uri=%@&response_type=%@",
                                   kAuthRequestURL,
                                   kClientID,
                                   kRedirectURI,
                                   kResponseType];
    NSURL *authUrl = [NSURL URLWithString:fullAuthUrlString];
    
    [[UIApplication sharedApplication] openURL:authUrl];
}

+ (void)loginWithURL:(NSURL*)url {
    NSString *code = [url absoluteString];
    code = [code stringByReplacingOccurrencesOfString:@"walkingmaks:?code=" withString:@""];
    
    [self requestTokenWithCode:code complete:^(NSDictionary *response) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationTokenWasAcquiredReadyToParce object:response];
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

+ (void)requestTokenWithCode:(NSString *)code complete:(IASuccesBlock)complBlock failure:(IAFailureBlock)failure {
    __block NSString *userName = @"";
    NSDictionary *params =
    @{@"code":code,
      @"client_id":kClientID,
      @"client_secret":kClientSecret,
      @"grant_type":kGrantType,
      @"redirect_uri":kRedirectURI
      };
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:kTokenRequestURL
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"%@", responseObject);
              NSString *token = [responseObject objectForKey:@"access_token"];
              [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
              [[NSUserDefaults standardUserDefaults] setObject:[[responseObject objectForKey:@"user"] objectForKey:@"full_name"] forKey:@"fullUserName"];
              [[NSUserDefaults standardUserDefaults] setObject:[[responseObject objectForKey:@"user"] objectForKey:@"username"] forKey:@"userLogin"];
              userName = [[responseObject objectForKey:@"user"] objectForKey:@"username"];
              if (userName.length > 0 ) {
                  [[NSNotificationCenter defaultCenter] postNotificationName:NotificationLoginWasAcquired object:userName];
              }
              [IAApiClient loadDataNextURL:nil completeBlock:complBlock failure:failure];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              failure(error);
          }];
}


@end
