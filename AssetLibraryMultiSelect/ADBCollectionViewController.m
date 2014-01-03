//
//  AssetLibraryMultiSelect
//
//  Copyright (c) 2013 Alexander Belliotti. All rights reserved.
//

#import "ADBCollectionViewController.h"

//#import "ADBDataSource.h"
#import "ADBCollectionView.h"

//#import "ADBHelpers.h"

@interface UICollectionViewController ()

@end

@implementation ADBCollectionViewController

#pragma mark -
#pragma mark UICollectionViewController

- (void)loadView {
    self.collectionView = [[ADBCollectionView alloc] initWithFrame:self.navigationController.view.frame
                                             collectionViewLayout:[self layout]];
    self.collectionView.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor blueColor];
}

#pragma mark - ADBCollectionViewController

- (UICollectionViewFlowLayout *)layout {
    return [[UICollectionViewFlowLayout alloc] init];
}

#pragma mark - ADBCollectionViewDelegate

- (BOOL)collectionView:(ADBCollectionView *)collectionView shouldLongPressItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(ADBCollectionView *)collectionView didLongPressItemAtIndexPath:(NSIndexPath *)indexPath {}

#pragma mark UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

@end
