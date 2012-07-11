//
//  MyFlowLayout.m
//  CollectionPlayground
//
//  Created by Brian Partridge on 6/17/12.
//  Copyright (c) 2012 Brian Partridge. All rights reserved.
//

#import "MyFlowLayout.h"

@implementation MyFlowLayout

- (id)init {
   id result = [super init];
   return result;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
   UICollectionViewLayoutAttributes *attrs = [super layoutAttributesForItemAtIndexPath:indexPath];
   return attrs;
}

//- (CGSize)collectionViewContentSize {
//   CGSize result = [super collectionViewContentSize];
//   result.height *= 2;
//   return  result;
//}

@end
