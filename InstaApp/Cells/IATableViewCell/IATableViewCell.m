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
@property (nonatomic, strong) IAModelItem *model;

@end

@implementation IATableViewCell

- (void)configWithModel:(IAModelItem *)model {
    self.labelCell.text = [model valueForKey:kModelDecriptionIA];
    NSURL *imageURL = [model valueForKey:kModelImgIA];
    [self.imageViewCell sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:kNoImage]];

}

@end
