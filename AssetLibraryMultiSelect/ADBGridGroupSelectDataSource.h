//
//  AssetLibraryMultiSelect
//
//  Copyright (c) 2013 Alexander Belliotti. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ADBDataSource.h"

#import "ADBAssetReader.h"

@class ADBGroupItem;
@class ADBGridGroupSelectController;

@interface ADBGridGroupSelectDataSource : ADBDataSource  <UICollectionViewDataSource, ADBAssetReaderDelegate>

@property (nonatomic, strong) ADBAssetReader *reader;
@property (nonatomic, weak) ADBGridGroupSelectController *controller;
//@property (nonatomic, weak) id<ADBThumbLoaderDelegate> delegate;

- (void)syncGroupCounts;
- (void)syncCountForGroupItem:(ADBGroupItem *)group;

- (BOOL)shouldToggleOn:(ALAssetsGroup *)group;
- (void)toggleGroupItems:(ADBGroupItem *)group;

@end
