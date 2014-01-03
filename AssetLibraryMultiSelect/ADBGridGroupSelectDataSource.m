//
//  AssetLibraryMultiSelect
//
//  Copyright (c) 2013 Alexander Belliotti. All rights reserved.
//

#import "ADBGridGroupSelectDataSource.h"


#import "ADBAssetItem.h"
#import "ADBGroupItem.h"
#import "ADBAssetStore.h"

#import "ADBTitledCollectionCell.h"

#import "ADBGridGroupSelectController.h"
#import "ADBCollectionViewController.h"

#import "ADBHelpers.h"

@interface ADBGridGroupSelectDataSource () {
    @protected
    BOOL _longPressFlag;
}

@property (nonatomic) NSMutableDictionary *groupSelectedCounts;

- (ADBAssetItem *)itemWithURL:(NSURL *)URL;

@end

@implementation ADBGridGroupSelectDataSource

- (id)init {
    self = [super init:YES];
    if (self) {
        _reader = [[ADBAssetReader alloc] init];
        self.reader.delegate = self;
        
        _groupSelectedCounts = [NSMutableDictionary dictionary];
    }
    
    return self;
}

#pragma mark -
#pragma mark - ADBGridGroupSelectDataSource

- (void)load {
    [self.reader readTopLevelGroups];
    [self syncGroupCounts];
}

- (void)syncGroupCounts {
    for (ADBGroupItem *group in self.items) {
        if (!group.groupURL) continue;
        [self syncCountForGroupItem:group];
    }
}

- (void)syncCountForGroupItem:(ADBGroupItem *)group {
    self.groupSelectedCounts[group.groupURL] = @([[ADBAssetStore instance] countForSelectedAssetsInGroup:group]);
}

- (BOOL)shouldToggleOn:(ALAssetsGroup *)group {
    NSURL *groupURL = [group valueForProperty:ALAssetsGroupPropertyURL];
    NSUInteger groupSelectedCount = [self.groupSelectedCounts[groupURL] unsignedIntegerValue];
    NSUInteger totalGroupCount = (NSUInteger)group.numberOfAssets;
    float percentageSelected = (float)groupSelectedCount / (float)totalGroupCount;
    BOOL shouldSelect = !(percentageSelected > .5f);
    return shouldSelect;
}

- (void)toggleGroupItems:(ADBGroupItem *)group {
    @synchronized (self) {
        _longPressFlag = YES;
        [self.reader readAssetsInGroup:group.assetGroup];
    }
}

#pragma mark Private

- (ADBAssetItem *)itemWithURL:(NSURL *)URL {
    if (!URL) return nil;
    
    ADBAssetItem *match = nil;
    
    for (ADBAssetItem *item in self.items) {
        if ([item.groupURL isEqual:URL]) {
            match = item;
            break;
        }
    }
    
    return match;
}

#pragma mark -
#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray *items = self.items;
    
    if (ADBIsCollectionWithObjects(items)) { return (NSInteger) items.count; }
    
    else return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ADBTitledCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ADBGridGroupSelectController reuseIDString]
                                                                           forIndexPath:indexPath];
    ADBGroupItem *item = [self itemAtIndexPath:indexPath];
    assert(item != nil);
    
    cell.thumbView.image = item.thumbImage;
    cell.titleLabel.text = item.groupName;
    
    return cell;
}

#pragma mark -
#pragma mark ADBAssetReaderDelegate

- (void)reader:(ADBAssetReader *)reader didReadTopLevelGroups:(NSArray *)groups {
    NSMutableArray *loadedIndexPaths = [NSMutableArray array];
    
    for (ADBGroupItem *item in groups) {
        if (![self.items containsObject:item]) {
            NSIndexPath *indexPath = [self addItem:item];
            [loadedIndexPaths addObject:indexPath];
        }
    }
    
    if (ADBIsCollectionWithObjects(loadedIndexPaths)) {
        [self.controller.collectionView insertItemsAtIndexPaths:loadedIndexPaths];
    }
}

- (void)reader:(ADBAssetReader *)reader didReadAsset:(ADBAssetItem *)asset inGroup:(ALAssetsGroup *)group moreComing:(BOOL)more {
    @synchronized (self) {
        if (!_longPressFlag) {
            NSIndexPath *indexPath = [self addItem:asset];
            [self.controller.collectionView insertItemsAtIndexPaths:@[ indexPath ]];
        } else {
            BOOL shouldSelect = [self shouldToggleOn:group];
            asset.selected = @(shouldSelect);
            
            if (shouldSelect) {
                [[ADBAssetStore instance] addAssetItem:asset];
            } else {
                [[ADBAssetStore instance] removeAssetItem:asset];
            }
            
            if (!more) {
                _longPressFlag = NO;
            }
        }
    }
}

- (void)reader:(ADBAssetReader *)reader didError:(NSError *)error {
    if (isAccessError(error)) {
        [ADBLibraryAccessDeniedPopup() show];
    }
    
    _longPressFlag = NO;
}

@end
