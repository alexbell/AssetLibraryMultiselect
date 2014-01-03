//
//  AssetLibraryMultiSelect
//
//  Copyright (c) 2013 Alexander Belliotti. All rights reserved.
//

#import "ADBMediaSelectDataSource.h"

#import "ADBGroupItem.h"
#import "ADBAssetItem.h"
#import "ADBAssetStore.h"

#import "ADBSelectCollectionCell.h"

#import "ADBMediaSelectController.h"
#import "ADBCollectionViewController.h"

#import "ADBHelpers.h"

const NSUInteger kInsertViewsThreshold     = 30;

@interface ADBMediaSelectDataSource ()

@property NSMutableArray *mediaItemsToInsert;

- (void)sortItems;

@end

@implementation ADBMediaSelectDataSource


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
    ADBSelectCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ADBMediaSelectController reuseIDString]
                                                                           forIndexPath:indexPath];
    
    ADBAssetItem *item = [self itemAtIndexPath:indexPath];
    assert(item != nil);
    
    cell.thumbView.image = item.thumbImage;
    
    //is the cell selected, if so give it a checkmark
    if ([[ADBAssetStore instance] assetItemIsSelected:item]) {
        [cell addCheckmark];
        [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    } else {
        [cell removeCheckmark];
    }
    
    //is the cell a video asset?  if so, put a movie overlay on it
    if (item.type == ADBAssetTypeVideo) {
        [cell addMovieOverlay:item.videoLength.unsignedIntegerValue];
    }
    
    return cell;
}

#pragma mark -
#pragma mark ADBDataSource

- (void)load {
    self.mediaItemsToInsert = [NSMutableArray arrayWithCapacity:kInsertViewsThreshold];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self.reader readAssetsInGroup:self.group.assetGroup];
    });
}

#pragma mark - ADBMediaSelectDataSource

- (id)initWithGroupItem:(ADBGroupItem *)group sortOrder:(ADBSortOrder)sortOrder {
    self = [super init:YES];
    if (self) {
        _reader = [[ADBAssetReader alloc] init];
        _reader.delegate = self;
        _group = group;
        _sortOrder = sortOrder;
    }
    
    return self;
}

- (void)sortItems {
    __weak ADBMediaSelectDataSource *selfRef = self;
    
    [self sortItemsUsing:^NSComparisonResult(id obj1, id obj2) {
        ADBAssetItem *one = obj1;
        ADBAssetItem *two = obj2;
        
        NSComparisonResult result = [one.creationDate compare:two.creationDate];
        if (selfRef.sortOrder == ADBSortOldestFirst) {
            return result;
        }
        
        if (result == NSOrderedAscending) return NSOrderedDescending;
        else if (result == NSOrderedDescending) return NSOrderedAscending;
        else return NSOrderedSame;
    }];
}

#pragma mark - 
#pragma mark ADBReaderDelegate

- (void)reader:(ADBAssetReader *)reader didReadTopLevelGroups:(NSArray *)groups {
    //we shouldn't ever be here
    assert(false);
}

- (void)reader:(ADBAssetReader *)reader didReadAsset:(ADBAssetItem *)asset inGroup:(ALAssetsGroup *)group moreComing:(BOOL)more {
    if ([self.items containsObject:asset]) {
        return;
    }
    
    [self.mediaItemsToInsert addObject:asset];
    
    if (self.mediaItemsToInsert.count == kInsertViewsThreshold || !more) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.controller.collectionView performBatchUpdates:^{
                NSArray *indexPathsToInsert = [self addItems:self.mediaItemsToInsert];
                [self.mediaItemsToInsert removeAllObjects];
                [self.controller.collectionView insertItemsAtIndexPaths:indexPathsToInsert];
            } completion:nil];
        });
    }
}

//TODO: catch more errors
- (void)reader:(ADBAssetReader *)reader didError:(NSError *)error {
    if (isAccessError(error)) {
        [ADBLibraryAccessDeniedPopup() show];
    }
    //NSLog(@"ERROR in MediaSelectDataSource from asset reader: %@", error.description);
}

@end
