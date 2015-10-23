//
//  ConstantsOfInstagramAPI.h
//  InstaApp
//
//  Created by Maks on 10/18/15.
//  Copyright © 2015 Maks. All rights reserved.
//

#ifndef ConstantsOfInstagramAPI_h
#define ConstantsOfInstagramAPI_h

static NSString *const kClientID = @"a74e8c6cdda541ccb2adcfa61bbc558b";
static NSString *const kClientSecret = @"63704247c8f54e84a84a5d1579df6537";
static NSString *const kGrantType = @"authorization_code";
static NSString *const kRedirectURI = @"walkingmaks://";

static NSString *const kTokenRequestURL = @"https://api.instagram.com/oauth/access_token";
static NSString *const kBaseRequestURL = @"https://api.instagram.com/v1/tags/vsco/media/recent?";
static NSString *const kAuthRequestURL = @"https://api.instagram.com/oauth/authorize/";

static NSString *const kScope = @"basic+likes";
static NSString *const kResponseType = @"code&scope=basic+likes";


#endif /* ConstantsOfInstagramAPI_h */
