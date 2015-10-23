//
//  IAApiClient.h
//  InstaApp
//
//  Created by Maks on 10/13/15.
//  Copyright © 2015 Maks. All rights reserved.
//

#import <Foundation/Foundation.h>

#warning Success, и лучше не answer, а response
typedef void (^IASuccesBlock)(NSDictionary *answer);
typedef void (^IAFailureBlock)(NSError *error);

@interface IAApiClient : NSObject

#warning вместо get лучше "load" или "request", так как операция длительная, а не мгновенная
+ (void) getDataNextURL:(NSString *)nextURL completeBlock:(IASuccesBlock)block failure:(IAFailureBlock)failure;

@end
