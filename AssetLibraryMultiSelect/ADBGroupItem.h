//
//  AssetLibraryMultiSelect
//
//  Copyright (c) 2013 Alexander Belliotti. All rights reserved.
//

#import "ADBAssetLibraryItem.h"

#import <AssetsLibrary/AssetsLibrary.h>

@interface ADBGroupItem : ADBAssetLibraryItem

@property (nonatomic) ALAssetsGroup *assetGroup;
@property (nonatomic) NSURL *groupURL;

+ (instancetype)itemWithGroup:(ALAssetsGroup *)group;

- (NSString *)groupName;
- (NSInteger)numberOfItems;

@end
