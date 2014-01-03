//
//  AssetLibraryMultiSelect
//
//  Copyright (c) 2013 Alexander Belliotti. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface ADBAssetLibraryItem : NSObject {
@protected
UIImage *_thumbImage;
}

- (void)setThumbImage:(UIImage *)thumb;
- (UIImage *)thumbImage;

@end
