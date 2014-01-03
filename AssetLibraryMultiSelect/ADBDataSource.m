//
//  AssetLibraryMultiSelect
//
//  Copyright (c) 2013 Alexander Belliotti. All rights reserved.
//

#import "ADBDataSource.h"

#import "ADBHelpers.h"

@interface ADBDataSource() {
    @private
    BOOL _isCollection;
}

@property NSMutableArray *backingItems;

- (NSInteger)itemOrRow:(NSIndexPath *)indexPath;

@end

@implementation ADBDataSource

- (id)init:(BOOL)isCollection {
    
    self = [super init];
    if (self) {
        _isCollection = isCollection;
        _backingItems = [NSMutableArray array];
    }
    
    return self;
}

#pragma mark -
#pragma mark ADBDataSource

- (NSUInteger)count {
    return self.backingItems.count;
}

- (NSArray *)items {
    return [NSArray arrayWithArray:self.backingItems];
}

- (id)itemAtIndexPath:(NSIndexPath *)path {
    if (!ADBIsCollectionWithObjects(self.backingItems)) return nil;
    
    @synchronized(_backingItems) {
        NSInteger itemOrRow = [self itemOrRow:path];
        if (self.backingItems.count - 1 >= itemOrRow) {
            return self.backingItems[itemOrRow];
        }
    }
    
    return nil;
}

- (NSIndexPath *)indexPathForItem:(id)item {
    if (!item) return nil;
    
    @synchronized (_backingItems) {
        NSUInteger index = [self.backingItems indexOfObject:item];
        if (index == NSNotFound) return nil;
        
        NSIndexPath *indexPath = nil;
        if (_isCollection) {
            indexPath = [NSIndexPath indexPathForItem:(NSInteger)index inSection:0];
        } else {
            indexPath = [NSIndexPath indexPathForRow:(NSInteger)index inSection:0];
        }
        
        return indexPath;
    }
}

- (NSIndexPath *)addItem:(id)item {
    NSUInteger backingItemsCount = 0;
    @synchronized (_backingItems) {
        backingItemsCount = self.backingItems.count;
        [self.backingItems addObject:item];
    }
    
    if (_isCollection) {
        return [NSIndexPath indexPathForItem:backingItemsCount inSection:0];
    } else {
        return [NSIndexPath indexPathForRow:backingItemsCount inSection:0];
    }
}

- (NSArray *)addItems:(NSArray *)items {
    NSUInteger backingItemsCount = 0;
    @synchronized (_backingItems) {
        backingItemsCount = self.backingItems.count;
        [self.backingItems addObjectsFromArray:items];
    }
    
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:items.count];
    for (NSUInteger i = backingItemsCount; i < backingItemsCount + items.count; i++) {
        if (_isCollection) {
            [indexPaths addObject:[NSIndexPath indexPathForItem:(NSInteger)i inSection:0]];
        } else {
            [indexPaths addObject:[NSIndexPath indexPathForRow:(NSInteger)i inSection:0]];
        }
    }
    
    return indexPaths;
}

- (NSIndexPath *)replaceItemAtIndex:(NSUInteger)index withItem:(id)item {
    @synchronized (_backingItems) {
        [self.backingItems replaceObjectAtIndex:(NSUInteger)index withObject:item];
    }
    
    if (_isCollection) {
        return [NSIndexPath indexPathForItem:(NSInteger)index inSection:0];
    } else {
        return [NSIndexPath indexPathForRow:(NSInteger)index inSection:0];
    }
}

- (void)removeItemAtIndex:(NSUInteger)index {
    @synchronized (_backingItems) {
        NSIndexSet *set = [NSIndexSet indexSetWithIndex:index];
        [self.backingItems removeObjectsAtIndexes:set];
    }
}

- (void)removeAllItems {
    @synchronized (_backingItems) {
        [self.backingItems removeAllObjects];
    }
}

- (void)sortItemsUsing:(ArrayComparisonBlock)comparisonBlock {
    if (!comparisonBlock) return;
    
    @synchronized (self) {
        [self.backingItems sortUsingComparator:comparisonBlock];
    }
}

#pragma mark Abstract

- (void)load {}

- (void)reload {}

#pragma mark Private

- (NSInteger)itemOrRow:(NSIndexPath *)indexPath {
	if (_isCollection) {
		return indexPath.item;
	} else {
		return indexPath.row;
	}
}

@end
