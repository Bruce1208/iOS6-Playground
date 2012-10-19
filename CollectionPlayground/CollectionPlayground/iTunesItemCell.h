//
//  iTunesItemCell.h
//  CollectionPlayground
//
//  Created by Brian Partridge on 6/19/12.
//  Copyright (c) 2012 Brian Partridge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface iTunesItemCell : UICollectionViewCell

@property (nonatomic, assign) CGFloat padding;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) CALayer *shadowLayer;
@property (nonatomic, strong) UILabel *titleLabel;

@end
