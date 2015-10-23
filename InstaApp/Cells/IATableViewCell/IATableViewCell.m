//
//  IATableViewCell.m
//  InstaApp
//
//  Created by Maks on 10/18/15.
//  Copyright © 2015 Maks. All rights reserved.
//

#import "IATableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface IATableViewCell()

@property (nonatomic, weak) IBOutlet UILabel *labelCell;
@property (nonatomic, weak) IBOutlet UIImageView *imageViewCell;

@end

@implementation IATableViewCell

- (void)configWithModel:(IAModelItem *)model {
    self.labelCell.text = model.caption;
    [self.imageViewCell sd_setImageWithURL:[NSURL URLWithString:model.imageURL] placeholderImage:[UIImage placeholderImage]];
}

@end
