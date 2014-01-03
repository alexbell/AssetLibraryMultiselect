//
//  AssetLibraryMultiSelect
//
//  Copyright (c) 2013 Alexander Belliotti. All rights reserved.
//

#import "ADBGroupItem.h"

#import "ADBHelpers.h"

@interface ADBGroupItem ()

@property (nonatomic, assign) NSInteger lastCount;

@end

@implementation ADBGroupItem

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[ADBGroupItem class]]) {
        ADBGroupItem *other = (ADBGroupItem *)object;
        if (other.groupURL && self.groupURL) {
            return [self.groupURL isEqual:other.groupURL];
        }
    }
    
    return NO;
}

+ (instancetype)itemWithGroup:(ALAssetsGroup *)group {
    ADBGroupItem *groupItem = [[self alloc] init];
    groupItem.assetGroup = group;
    groupItem.thumbImage = [UIImage imageWithCGImage:group.posterImage];
    groupItem.lastCount = groupItem.numberOfItems;
    groupItem.groupURL = [group valueForProperty:ALAssetsGroupPropertyURL];
    
    return groupItem;
}

- (UIImage *)thumbImage {
    @synchronized (self) {
        if (!_thumbImage) {
            _thumbImage = [UIImage imageWithCGImage:[self.assetGroup posterImage]];
        }
    }
    
    return _thumbImage;
}

- (NSString *)groupName {
    return [self.assetGroup valueForProperty:ALAssetsGroupPropertyName];
}

- (NSInteger)numberOfItems {
    NSInteger toReturn = 0;
    if (!!self.assetGroup) {
        toReturn = self.assetGroup.numberOfAssets;
    }
    
    return toReturn;
}

- (NSString *)persistentID {
    return [self.assetGroup valueForProperty:ALAssetsGroupPropertyPersistentID];
}

@end
