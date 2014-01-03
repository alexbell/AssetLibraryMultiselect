//
//  AssetLibraryMultiSelect
//
//  Copyright (c) 2013 Alexander Belliotti. All rights reserved.
//

#import "ADBCollectionViewCell.h"

@interface ADBTitledCollectionCell : ADBCollectionViewCell

@property (nonatomic,readonly) UILabel *titleLabel;
@property (nonatomic, readonly) UILabel *selectedCountLabel;

- (void)setSelectedCount:(NSUInteger)count;

@end
