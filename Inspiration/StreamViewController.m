//
//  ViewController.m
//  Inspiration
//
//  Created by Ethan Mick on 10/11/12.
//  Copyright (c) 2012 Ethan Mick. All rights reserved.
//

#import "StreamViewController.h"
#import "StreamCell.h"

@interface StreamViewController ()

@property (nonatomic, strong) NSMutableArray *streamItems;

@end

@implementation StreamViewController

@synthesize streamItems;


- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.collectionView registerClass:[StreamCell class] forCellWithReuseIdentifier:@"STREAM_CELL"];
    self.streamItems = [[NSMutableArray alloc] init];
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    flowLayout.minimumLineSpacing = 30.0;
    flowLayout.minimumInteritemSpacing = 20.0;
    flowLayout.sectionInset = UIEdgeInsetsMake(23.6, 23.6, 23.6, 0);
    
    ///
    /// Load items from Cloudmine
    ///

    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView Delegate Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.streamItems count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    StreamCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"STREAM_CELL" forIndexPath:indexPath];
    
    
    
    return cell;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self.collectionView.collectionViewLayout invalidateLayout];
}

#pragma mark - UICollectionViewFlowLayout Deleage Methods

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(140, 140);

}

@end
