//
//  IAApiClient.h
//  InstaApp
//
//  Created by Maks on 10/13/15.
//  Copyright © 2015 Maks. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^IASuccesBlock)(NSDictionary *response);
typedef void (^IAFailureBlock)(NSError *error);

@interface IAApiClient : NSObject

+ (void) loadDataNextURL:(NSString *)nextURL completeBlock:(IASuccesBlock)block failure:(IAFailureBlock)failure;

@end
