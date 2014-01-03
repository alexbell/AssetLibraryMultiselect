//
//  AssetLibraryMultiSelect
//
//  Copyright (c) 2013 Alexander Belliotti. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NIToolbarPhotoViewController.h"
#import "NIPhotoScrubberView.h"

#import "ADBMovieDetailViewDelegate.h"

@class ADBAssetItem;
@class ADBMediaDetailDataSource;

@interface ADBMediaDetailController : NIToolbarPhotoViewController <NIPhotoScrubberViewDelegate>

@property (nonatomic) ADBMediaDetailDataSource *dataSource;

- (id)initWithSelectedItem:(ADBAssetItem *)item inItems:(NSArray *)items;

- (ADBAssetItem *)currentCenterItem;

//here to silence unknown selector warning in movieScrollView
- (void)movieOverlayTapped;

@end
