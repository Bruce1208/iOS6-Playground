//
//  PileLayout.m
//  CollectionPlayground
//
//  Created by Brian Partridge on 6/17/12.
//  Copyright (c) 2012 Brian Partridge. All rights reserved.
//

#import "PileLayout.h"
#import <QuartzCore/QuartzCore.h>

CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};
CGFloat RadiansToDegrees(CGFloat radians) {return radians * 180 / M_PI;};

@implementation PileLayout

- (id)init {
	if ((self = [super init])) {
		_itemSize = CGSizeMake(50, 50);
      _layoutStyle = PileLayoutStyleStack;
	}
	return self;
}

- (CGSize)collectionViewContentSize {
   return self.collectionView.frame.size;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
   return YES;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
   NSMutableArray *result = [NSMutableArray array];
   NSUInteger sectionCount = self.collectionView.numberOfSections;
   for (NSUInteger i = 0; i < sectionCount; i++) {
      NSUInteger itemCount = [self.collectionView numberOfItemsInSection:i];
      for (NSUInteger j = 0; j < itemCount; j++) {
         NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
         UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:indexPath];
         [result addObject:attr];
      }
   }
   return result;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
   UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];

   if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)]) {
      attr.size = [(id<PileLayoutDelegate>)self.collectionView.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
   } else {
      attr.size = self.itemSize;
   }

   if (_layoutStyle == PileLayoutStyleStack ||
       _layoutStyle == PileLayoutStyleAskew ||
       _layoutStyle == PileLayoutStyleSpin) {
      attr.center = CGPointMake(CGRectGetMidX(self.collectionView.frame), CGRectGetMidY(self.collectionView.frame));

      if (_layoutStyle == PileLayoutStyleAskew) {
         CGFloat angle = DegreesToRadians(2 * indexPath.item);
         attr.transform3D = CATransform3DMakeRotation(angle, 0, 0, 1);
      } else if (_layoutStyle == PileLayoutStyleSpin) {
         CGFloat angle = DegreesToRadians(indexPath.item * 360 / [self.collectionView numberOfItemsInSection:indexPath.section]);
         attr.transform3D = CATransform3DMakeRotation(angle, 0, 0, 1);
      }
   } else if (_layoutStyle == PileLayoutStyleFan) {
      NSUInteger count = [self.collectionView numberOfItemsInSection:indexPath.section];
      CGFloat factor = (indexPath.item - (count / 2.0)) / count;
      NSLog(@"%d - %f", indexPath.item, factor);

      // This needs to be rethought and the z indexing doesn't make sense

      attr.center = CGPointMake(CGRectGetMidX(self.collectionView.frame) + factor * 140,
                                CGRectGetMidY(self.collectionView.frame));

      CGFloat angle = DegreesToRadians(factor * 60);
      attr.transform3D = CATransform3DMakeRotation(angle, 0, 0, 1);
   }

   NSInteger itemsInSectionCount = [self.collectionView numberOfItemsInSection:indexPath.section];
   NSInteger desiredZIndex = itemsInSectionCount - indexPath.item;
   //   attr.zIndex = desiredZIndex; // zIndex isn't respected when changing between layouts
   attr.transform3D = CATransform3DConcat(attr.transform3D, CATransform3DMakeTranslation(0, 0, desiredZIndex)); // Achieve the desired z order with a transform

   return attr;
}

@end
