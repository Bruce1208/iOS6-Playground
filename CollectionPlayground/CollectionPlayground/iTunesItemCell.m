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
    }
    return self;
}

- (void)layoutSubviews {
   self.shadowLayer.frame = self.bounds;

   self.imageView.frame = CGRectMake(self.padding, self.padding, self.imageView.image.size.width, self.imageView.image.size.height);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
