//
//  AssetLibraryMultiSelect
//
//  Copyright (c) 2013 Alexander Belliotti. All rights reserved.
//

#import "ADBDataSource.h"

#import "ADBAssetReader.h"

@class ADBGroupItem;
@class ADBMediaSelectController;

typedef enum {
    ADBSortOldestFirst,
    ADBSortRecentFirst
} ADBSortOrder;

@interface ADBMediaSelectDataSource : ADBDataSource <UICollectionViewDataSource, ADBAssetReaderDelegate>

@property (nonatomic) ADBAssetReader *reader;
@property (nonatomic) ADBGroupItem *group;

@property (assign) ADBSortOrder sortOrder;

@property (nonatomic, weak) ADBMediaSelectController *controller;

- (id)initWithGroupItem:(ADBGroupItem *)group sortOrder:(ADBSortOrder)sortOrder;

@end
