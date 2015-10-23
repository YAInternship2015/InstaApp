//
//  UIImage+setNoImage.m
//  InstaApp
//
//  Created by Maks on 10/23/15.
//  Copyright © 2015 Maks. All rights reserved.
//

#import "UIImage+setNoImage.h"

@implementation UIImage (setNoImage)

+ (UIImage *)placeholderImage {
    return [UIImage imageNamed:@"noPic"];
}

@end
