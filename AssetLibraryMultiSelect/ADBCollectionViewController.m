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
}

- (void)viewDidLoad {
    Class cellClass = [[self class] cellClass];
    NSString *reuseIDString = [[self class] reuseIDString];
    [self.collectionView registerClass:cellClass forCellWithReuseIdentifier:reuseIDString];
    self.collectionView.delegate = self;
    
    self.navigationController.navigationBar.barTintColor = [UIColor blueColor];
}

#pragma mark - ADBCollectionViewController

- (UICollectionViewFlowLayout *)layout {
    return [[UICollectionViewFlowLayout alloc] init];
}

+ (Class)cellClass {
    return [UICollectionViewCell class];
}

+ (NSString *)reuseIDString {
    return @"ACollectionViewCell";
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
