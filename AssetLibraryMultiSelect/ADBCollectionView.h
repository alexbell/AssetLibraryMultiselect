//
//  AssetLibraryMultiSelect
//
//  Copyright (c) 2013 Alexander Belliotti. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ADBCollectionView : UICollectionView

@property (nonatomic, weak) UILongPressGestureRecognizer *longPressRecognizer;

@end

@protocol ADBCollectionViewDelegate <UICollectionViewDelegateFlowLayout>

- (BOOL)collectionView:(ADBCollectionView *)collectionView shouldLongPressItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(ADBCollectionView *)collectionView didLongPressItemAtIndexPath:(NSIndexPath *)indexPath;

@end
