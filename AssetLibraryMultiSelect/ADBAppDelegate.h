//
//  AssetLibraryMultiSelect
//
//  Copyright (c) 2013 Alexander Belliotti. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ALAssetsLibrary;

@interface ADBAppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UINavigationController *navController;

@end
