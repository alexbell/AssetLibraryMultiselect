//
//  AssetLibraryMultiSelect
//
//  Copyright (c) 2013 Alexander Belliotti. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ALAssetsLibrary;
@class ADBAppDelegate;

BOOL ADBIsTablet();
BOOL ADBIsStringWithText(id object);
BOOL ADBIsCollectionWithObjects(id object);
NSString* ADBCoalesceString(NSString *string);

ALAssetsLibrary* assetsLibrary();

BOOL isAccessError(NSError *error);
UIAlertView* ADBPopup(NSString *title, NSString *message);
UIAlertView* ADBPopupDismiss(NSString *title, NSString *message, NSString *dismissTitle);

UIAlertView* ADBLibraryAccessDeniedPopup();

CGFloat distanceBetweenPoints(CGPoint a, CGPoint b);
CGRect logRect(CGRect rect);

@interface ADBHelpers : NSObject

+ (ADBAppDelegate *)app;

@end
