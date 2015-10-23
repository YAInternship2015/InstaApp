//
//  IACollectionViewCell.m
//  InstaApp
//
//  Created by Maks on 10/22/15.
//  Copyright © 2015 Maks. All rights reserved.
//

#import "IACollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface IACollectionViewCell()

@property (nonatomic, weak) IBOutlet UIImageView *imageViewCell;

@end

@implementation IACollectionViewCell

- (void)configWithModel:(IAModelItem *)model {
    [self.imageViewCell sd_setImageWithURL:[NSURL URLWithString:model.imageURL] placeholderImage:[UIImage placeholderImage]];
}


@end
