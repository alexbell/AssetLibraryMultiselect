//
//  AssetLibraryMultiSelect
//
//  Copyright (c) 2013 Alexander Belliotti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADBCollectionViewCell : UICollectionViewCell

@property (nonatomic) UIImageView *thumbView;

@property (nonatomic) UIImageView *movieView;
@property (nonatomic) UILabel *movieLabel;

- (void)addMovieOverlay:(NSUInteger)movieLength;
- (void)removeMovieOverlay;

@end
