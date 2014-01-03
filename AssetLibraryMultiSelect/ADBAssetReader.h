//
//  AssetLibraryMultiSelect
//
//  Copyright (c) 2013 Alexander Belliotti. All rights reserved.
//
#import <Foundation/Foundation.h>

#import <AssetsLibrary/AssetsLibrary.h>

@class ADBAssetItem;
@class ADBGuidedShareConstraints;

@protocol ADBAssetReaderDelegate;

@interface ADBAssetReader : NSObject

@property (nonatomic) ALAssetsLibrary *library;
@property (nonatomic, weak) id<ADBAssetReaderDelegate> delegate;

- (void)readTopLevelGroups;

- (void)readAssetsInGroup:(ALAssetsGroup *)group;
- (void)stopReadingAssets;

@end

@protocol ADBAssetReaderDelegate <NSObject>

- (void)reader:(ADBAssetReader *)reader didError:(NSError *)error;

@optional

- (void)reader:(ADBAssetReader *)reader didReadTopLevelGroups:(NSArray *)groups;
- (void)reader:(ADBAssetReader *)reader didReadAsset:(ADBAssetItem *)asset inGroup:(ALAssetsGroup *)group moreComing:(BOOL)more;

@end
