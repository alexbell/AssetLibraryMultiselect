//
//  AssetLibraryMultiSelect
//
//  Copyright (c) 2013 Alexander Belliotti. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ADBMovieScrollView;

@protocol ADBMovieDetailViewDelegate <NSObject>

- (void)playMovieInDetailView:(ADBMovieScrollView *)view;

@end
