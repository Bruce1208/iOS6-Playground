//
//  iTunesItemCell.m
//  CollectionPlayground
//
//  Created by Brian Partridge on 6/19/12.
//  Copyright (c) 2012 Brian Partridge. All rights reserved.
//

#import "iTunesItemCell.h"

@implementation iTunesItemCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
       self.backgroundColor = [UIColor whiteColor];
       self.padding = 0;
       self.imageView = [[UIImageView alloc] init];
       [self.contentView addSubview:self.imageView];
       self.titleLabel = [[UILabel alloc] init];
       [self.contentView addSubview:self.titleLabel];

       self.selectedBackgroundView = [[UIView alloc] init];
       self.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.4];
    }
    return self;
}

- (void)layoutSubviews {
   self.shadowLayer.frame = self.bounds;

   self.imageView.frame = CGRectMake(self.padding, self.padding, self.imageView.image.size.width, self.imageView.image.size.height);

   CGFloat textHeight = 20;
   self.titleLabel.frame = CGRectMake(0, self.frame.size.height - textHeight, self.frame.size.width, textHeight);

   self.selectedBackgroundView.frame = self.bounds;
}

@end
