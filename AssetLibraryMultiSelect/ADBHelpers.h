//
//  AssetLibraryMultiSelect
//
//  Copyright (c) 2013 Alexander Belliotti. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ALAssetsLibrary;
@class ADBAppDelegate;

BOOL ADBIsTablet(void);
BOOL ADBIsStringWithText(id object);
BOOL ADBIsCollectionWithObjects(id object);
NSString* ADBCoalesceString(NSString *string);

ALAssetsLibrary* assetsLibrary(void);

BOOL isAccessError(NSError *error);
UIAlertView* ADBPopup(NSString *title, NSString *message);
UIAlertView* ADBPopupDismiss(NSString *title, NSString *message, NSString *dismissTitle);

UIAlertView* ADBLibraryAccessDeniedPopup(void);

CGFloat distanceBetweenPoints(CGPoint a, CGPoint b);
CGRect logRect(CGRect rect);

@interface ADBHelpers : NSObject

+ (ADBAppDelegate *)app;

@end
