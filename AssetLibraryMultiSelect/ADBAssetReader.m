//
//  AssetLibraryMultiSelect
//
//  Copyright (c) 2013 Alexander Belliotti. All rights reserved.
//

#import "ADBAssetReader.h"

#import "ADBGroupItem.h"
#import "ADBAssetItem.h"

#import "ADBAssetStore.h"

#import "ADBHelpers.h"

@interface ADBAssetReader ()

@property (atomic) NSNumber *stopFlag;

- (void)fetchedTopLevelGroups:(NSArray *)groups;

@end

BOOL assetGroupIsCameraRoll(ALAssetsGroup *group) {
    ALAssetsGroupType type = [[group valueForProperty:ALAssetsGroupPropertyType] intValue];
    return (type == ALAssetsGroupSavedPhotos);
}

@implementation ADBAssetReader

#pragma mark -
#pragma mark Init

- (id)init {
    self = [super init];
    if (self) {
        _library = assetsLibrary();
        _stopFlag = @NO;
    }
    
    return self;
}

#pragma mark -
#pragma mark Reading

- (void)readTopLevelGroups {
    __weak ADBAssetReader *selfRef = self;
    __block NSMutableArray *groups = [NSMutableArray array];
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        [selfRef.library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos | ALAssetsGroupAlbum
                                       usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                                           if (group && group.numberOfAssets > 0) {
                                               [groups addObject:group];
                                           } else {
                                               [selfRef fetchedTopLevelGroups:groups];
                                           }
                                       } failureBlock:^(NSError *error) {
                                           [selfRef.delegate reader:selfRef didError:error];
                                       }];
    });
}

- (void)readAssetsInGroup:(ALAssetsGroup *)group {
    __block NSInteger totalAssets = group.numberOfAssets;
    __block NSInteger fetchedAssets = 0;
    __weak ADBAssetReader *selfRef = self;
    
    [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if ([self.stopFlag boolValue]) {
            *stop = YES;
            return;
        } else if (result) {
            fetchedAssets++;
            ADBAssetItem *assetItem = [ADBAssetItem itemWithAsset:result];
            assetItem.groupURL = [group valueForProperty:ALAssetsGroupPropertyURL];
            
            @synchronized(selfRef.delegate) {
                [selfRef.delegate reader:selfRef
                            didReadAsset:assetItem
                                 inGroup:group
                              moreComing:fetchedAssets < totalAssets];
            }
        }
    }];
}

- (void)stopReadingAssets {
    @synchronized(self) {
        self.stopFlag = @YES;
    }
}

#pragma mark Private

- (void)fetchedTopLevelGroups:(NSArray *)groups {
    if (!ADBIsCollectionWithObjects(groups)) return;
    
    NSArray *sortedGroups = [groups sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        ALAssetsGroup *group1 = (ALAssetsGroup *)obj1;
        ALAssetsGroup *group2 = (ALAssetsGroup *)obj2;
        
        if (assetGroupIsCameraRoll(group1) || assetGroupIsCameraRoll(group2)) {
            
            BOOL group1IsCameraRoll = assetGroupIsCameraRoll(group1);
            NSComparisonResult toReturn = group1IsCameraRoll ? NSOrderedAscending : NSOrderedDescending;
            return toReturn;
        }
        
        NSString *group1Name = [group1 valueForProperty:ALAssetsGroupPropertyName];
        NSString *group2Name = [group2 valueForProperty:ALAssetsGroupPropertyName];
        
        return [group1Name compare:group2Name options:NSCaseInsensitiveSearch];
    }];
    
    
    NSMutableArray *groupItems = [NSMutableArray arrayWithCapacity:sortedGroups.count];
    for (ALAssetsGroup *group in sortedGroups) {
        [groupItems addObject:[ADBGroupItem itemWithGroup:group]];
    }
    
    __weak typeof(self) welf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [welf.delegate reader:self didReadTopLevelGroups:groupItems];
    });
}

@end
