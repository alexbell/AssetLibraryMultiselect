//
//  AssetLibraryMultiSelect
//
//  Copyright (c) 2013 Alexander Belliotti. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSComparisonResult (^ArrayComparisonBlock)(id obj1, id obj2);

@interface ADBDataSource : NSObject 

- (id)init:(BOOL)isCollection;

- (NSUInteger)count;
- (NSArray *)items;
- (id)itemAtIndexPath:(NSIndexPath *)path;
- (NSIndexPath *)indexPathForItem:(id)item;

- (NSIndexPath *)addItem:(id)item;
- (NSArray *)addItems:(NSArray *)items;

- (NSIndexPath *)replaceItemAtIndex:(NSUInteger)index withItem:(id)item;

- (void)removeItemAtIndex:(NSUInteger)index;
- (void)removeAllItems;

- (void)sortItemsUsing:(ArrayComparisonBlock)comparisonBlock;

//for subclasses
- (void)load;
- (void)reload;

@end
