//
//  AssetLibraryMultiSelect
//
//  Copyright (c) 2013 Alexander Belliotti. All rights reserved.
//

#import "ADBAssetLibraryItem.h"

#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

typedef enum {
    ADBAssetTypePhoto,
    ADBAssetTypeVideo,
    ADBAssetTypeUnknown
} ADBAssetType;

@interface ADBAssetItem : ADBAssetLibraryItem

@property (nonatomic) ALAsset *asset;
@property (nonatomic) AVAsset *avAsset;

@property (nonatomic, copy) NSURL *defaultAssetURL;
@property (nonatomic, copy) NSURL *groupURL;

@property (nonatomic, assign) ADBAssetType type;
@property (nonatomic) NSDate *creationDate;
@property (nonatomic, copy) NSString *fileExtension;

+ (instancetype)itemWithAsset:(ALAsset *)asset;

- (UIImage *)detailImage;

- (NSNumber *)videoLength;

@end
