//
//  AssetLibraryMultiSelect
//
//  Copyright (c) 2013 Alexander Belliotti. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NIPhotoAlbumScrollViewDataSource.h"
#import "NIPhotoScrubberView.h"

@class ADBAssetItem;
@class ADBMediaDetailController;

@interface ADBMediaDetailDataSource : NSObject <NIPhotoAlbumScrollViewDataSource, NIPhotoScrubberViewDataSource>

@property (nonatomic) NSArray *items;
@property (nonatomic, weak) ADBMediaDetailController *controller;

- (id)initWithItems:(NSArray *)items;

- (void)loadImageForIndex:(NSInteger)index;

@end
