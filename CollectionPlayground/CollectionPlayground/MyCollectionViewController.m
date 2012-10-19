//
//  MyCollectionViewController.m
//  CollectionPlayground
//
//  Created by Brian Partridge on 6/17/12.
//  Copyright (c) 2012 Brian Partridge. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "iTunesScrapper.h"
#import "iTunesItemCell.h"

#define PADDING 1

@interface MyCollectionViewController () <SKStoreProductViewControllerDelegate>

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSArray *layouts;
@property (nonatomic, assign) NSUInteger layoutIndex;

@end

@implementation MyCollectionViewController

+ (UICollectionViewFlowLayout *)flowLayout {
   static UICollectionViewFlowLayout *layout = nil;
   static dispatch_once_t onceToken;
   dispatch_once(&onceToken, ^{
      layout = [[UICollectionViewFlowLayout alloc] init];
   });
   return layout;
}

+ (PileLayout *)stackLayout {
   static PileLayout *layout = nil;
   static dispatch_once_t onceToken;
   dispatch_once(&onceToken, ^{
      layout = [[PileLayout alloc] init];
      layout.layoutStyle = PileLayoutStyleStack;
   });
   return layout;
}

+ (PileLayout *)fanLayout {
   static PileLayout *layout = nil;
   static dispatch_once_t onceToken;
   dispatch_once(&onceToken, ^{
      layout = [[PileLayout alloc] init];
      layout.layoutStyle = PileLayoutStyleFan;
   });
   return layout;
}

+ (PileLayout *)askewLayout {
   static PileLayout *layout = nil;
   static dispatch_once_t onceToken;
   dispatch_once(&onceToken, ^{
      layout = [[PileLayout alloc] init];
      layout.layoutStyle = PileLayoutStyleAskew;
   });
   return layout;
}

+ (PileLayout *)spinLayout {
   static PileLayout *layout = nil;
   static dispatch_once_t onceToken;
   dispatch_once(&onceToken, ^{
      layout = [[PileLayout alloc] init];
      layout.layoutStyle = PileLayoutStyleSpin;
   });
   return layout;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

   self.title = @"Top Movies";
   [self.collectionView registerClass:[iTunesItemCell class] forCellWithReuseIdentifier:@"Cell"];
   self.collectionView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
   self.layouts = @[[[self class] flowLayout],
   [[self class] stackLayout], [[self class] askewLayout],
   [[self class] stackLayout], [[self class] spinLayout],
   [[self class] stackLayout], [[self class] fanLayout]];
   _layoutIndex = 0;
   self.collectionView.collectionViewLayout = [_layouts objectAtIndex:_layoutIndex];

//   UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTapped:)];
//   self.navigationItem.rightBarButtonItem = add;

   UIBarButtonItem *swap = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(swapTapped:)];
   self.navigationItem.leftBarButtonItem = swap;
}

- (void)viewDidAppear:(BOOL)animated {
   [super viewDidAppear:animated];
   
   [[iTunesScrapper sharedInstance] topMovies:^(NSArray *movies) {
      NSOperation *finalize = [NSBlockOperation blockOperationWithBlock:^{
         self.items = movies;
         [self.collectionView reloadData];
      }];

      NSOperationQueue *queue = [[NSOperationQueue alloc] init];
      for (iTunesItem *item in movies) {
         NSURLRequest *req = [NSURLRequest requestWithURL:item.imageURL];
         NSOperation *op = [NSBlockOperation blockOperationWithBlock:^{
            NSURLResponse *response = nil;
            NSError *error = nil;
            NSData *data = [NSURLConnection sendSynchronousRequest:req returningResponse:&response error:&error];
            if (error != nil) {
               NSLog(@"%@ - error = %@", item.imageURL, error);
            } else {
               item.image = [UIImage imageWithData:data];
            }
         }];

         [finalize addDependency:op];
         [queue addOperation:op];
      }

      [[NSOperationQueue mainQueue] addOperation:finalize];
   }];
}

- (void)swapTapped:(id)sender {
   _layoutIndex = (++_layoutIndex % self.layouts.count);

   UICollectionViewLayout *layout = [self.layouts objectAtIndex:_layoutIndex];
   [self.collectionView setCollectionViewLayout:layout animated:YES];
}

//- (void)addTapped:(id)sender {
//   self.count++;
//
//   [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:self.count-1 inSection:0]]];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - UICollectionViewDatasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
   return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
   return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
   iTunesItemCell *cell = (iTunesItemCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
   cell.contentView.backgroundColor = [UIColor whiteColor];

   iTunesItem *item = [self.items objectAtIndex:indexPath.item];
   cell.imageView.image = item.image;
   cell.padding = 4;

//   if (cell.shadowLayer == nil) {
//      CALayer *shadowLayer = [CALayer layer];
//      shadowLayer.frame = cell.bounds;
//      shadowLayer.backgroundColor = [UIColor orangeColor].CGColor;
//      shadowLayer.shadowColor = [UIColor blackColor].CGColor;
//      shadowLayer.shadowOffset = CGSizeMake(0, 0);
//      shadowLayer.shadowOpacity = 0.3;
//      shadowLayer.shadowRadius = 4;
//      [cell.layer insertSublayer:shadowLayer atIndex:0];
//   }

   return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
   iTunesItem *item = [self.items objectAtIndex:indexPath.item];
   SKStoreProductViewController *vc = [[SKStoreProductViewController alloc] init];
   vc.delegate = self;
   NSDictionary *params = @{ SKStoreProductParameterITunesItemIdentifier : item.trackId };
   [vc loadProductWithParameters:params completionBlock:^(BOOL result, NSError *error) {
      if (result) {
         [self presentViewController:vc animated:YES completion:nil];
      } else {
         NSLog(@"error = %@", error);
      }
   }];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
   iTunesItem *item = [self.items objectAtIndex:indexPath.item];
   CGSize size = item.image.size;
   CGFloat padding = PADDING;
   return CGSizeMake(size.width + padding * 2, size.height + padding * 2);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
   return UIEdgeInsetsMake(10, 10, 10, 10);
}

#pragma mark - SKStoreProductViewControllerDelegate

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
   [self dismissViewControllerAnimated:YES completion:nil];
}

@end
