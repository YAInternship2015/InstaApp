//
//  IADataManager.h
//  InstaApp
//
//  Created by Maks on 10/18/15.
//  Copyright © 2015 Maks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IALoader : NSObject

+ (id)dataLoader;

- (void)requestTokenWithRecievedURL:(NSURL *)url;

@end
