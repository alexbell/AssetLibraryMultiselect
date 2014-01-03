//
//  AssetLibraryMultiSelect
//
//  Copyright (c) 2013 Alexander Belliotti. All rights reserved.
//

#import "ADBAssetItem.h"

#import <AVFoundation/AVFoundation.h>

#import "ADBHelpers.h"

@implementation ADBAssetItem

- (BOOL)isEqual:(id)object {
    if (!object) return NO;
    else if (![object isKindOfClass:[ADBAssetItem class]]) return NO;
    
    ADBAssetItem *other = object;
    if (!self.asset || !other.asset) return NO;
    else {
        return [self.defaultAssetURL isEqual:other.defaultAssetURL];
    }
}

- (NSString *)description {
    NSString *desc = [NSString stringWithFormat:@"asset:%@ | isSelected:%ld",
                      self.asset.defaultRepresentation.url.absoluteString, (long)self.isSelected.integerValue];
    return desc;
}

+ (instancetype)itemWithAsset:(ALAsset *)asset {
    if (!asset) return nil;
    
    ADBAssetItem * item = [[self alloc] init];
    item.asset = asset;
    item.defaultAssetURL = asset.defaultRepresentation.url;
    
    NSString *assetTypeString = [asset valueForProperty:ALAssetPropertyType];
    if ([assetTypeString isEqualToString:ALAssetTypePhoto]) {
        item.type = ADBAssetTypePhoto;
    } else if ([assetTypeString isEqualToString:ALAssetTypeVideo]) {
        item.type = ADBAssetTypeVideo;
    } else {
        item.type = ADBAssetTypeUnknown;
    }
    
    item.creationDate = [asset valueForProperty:ALAssetPropertyDate];
    NSArray *pathComponents = [[asset.defaultRepresentation filename] componentsSeparatedByString:@"."];
    if (ADBIsCollectionWithObjects(pathComponents)) {
        item.fileExtension = [pathComponents lastObject];
    }
    
    
    return item;
}

- (UIImage *)thumbImage {
    @synchronized (self) {
        if (!_thumbImage) {
            _thumbImage = [UIImage imageWithCGImage:[self.asset thumbnail]];
        }
    }
    
    return _thumbImage;
}

- (UIImage *)detailImage {
    CGImageRef defaultFullScreenImageRef = [[self.asset defaultRepresentation] fullScreenImage];
    if (defaultFullScreenImageRef == NULL) { return nil; }
    
    return [UIImage imageWithCGImage:defaultFullScreenImageRef];
}

- (AVAsset *)avAsset {
    BOOL hasAvAsset = !!_avAsset && !(_avAsset == (AVAsset *)[NSNull null]);
    if (!hasAvAsset && self.type == ADBAssetTypeVideo) {
        _avAsset = [AVAsset assetWithURL:self.defaultAssetURL];
    }
    
    return _avAsset;
}

- (NSNumber *)isSelected {
    if (!_selected) {
        return @NO;
    } else {
        return _selected;
    }
}

- (NSNumber *)videoLength {
    if (self.type != ADBAssetTypeVideo) return nil;
    
    if (!self.avAsset) return nil;
    
    CMTime time = self.avAsset.duration;
    return [NSNumber numberWithDouble:CMTimeGetSeconds(time)];
}

@end
