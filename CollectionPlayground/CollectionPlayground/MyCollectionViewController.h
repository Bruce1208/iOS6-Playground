//
//  MyCollectionViewController.h
//  CollectionPlayground
//
//  Created by Brian Partridge on 6/17/12.
//  Copyright (c) 2012 Brian Partridge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PileLayout.h"
#import <StoreKit/StoreKit.h>

@interface MyCollectionViewController : UICollectionViewController <UICollectionViewDelegateFlowLayout, PileLayoutDelegate, SKStoreProductViewControllerDelegate>

+ (UICollectionViewFlowLayout *)flowLayout;
+ (PileLayout *)stackLayout;
+ (PileLayout *)fanLayout;
+ (PileLayout *)askewLayout;
+ (PileLayout *)spinLayout;

@end
