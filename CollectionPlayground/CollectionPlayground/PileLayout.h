//
//  PileLayout.h
//  CollectionPlayground
//
//  Created by Brian Partridge on 6/17/12.
//  Copyright (c) 2012 Brian Partridge. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
   PileLayoutStyleStack,
   PileLayoutStyleAskew,
   PileLayoutStyleSpin,
   PileLayoutStyleFan,
} PileLayoutStyle;

@protocol PileLayoutDelegate
@optional

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface PileLayout : UICollectionViewLayout

@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, assign) PileLayoutStyle layoutStyle;

@end
