//
//  AssetLibraryMultiSelect
//
//  Copyright (c) 2013 Alexander Belliotti. All rights reserved.
//

#import "NIPhotoScrollView.h"

@class ADBPlayMovieOverlay;
@class ADBMediaDetailController;

@interface ADBMovieScrollView : NIPhotoScrollView

@property (nonatomic) ADBPlayMovieOverlay *overlay;

- (id)initWithFrame:(CGRect)frame detailController:(ADBMediaDetailController *)controller;

@end
