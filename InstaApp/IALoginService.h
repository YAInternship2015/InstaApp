//
//  IALogin.h
//  InstaApp
//
//  Created by Maks on 10/18/15.
//  Copyright © 2015 Maks. All rights reserved.
//

#import <Foundation/Foundation.h>

//#warning плохое имя класса, надо переименовать
@interface IALoginService : NSObject

+ (void)loginWithURL:(NSURL*)url;

+ (void)startLogin;

@end
