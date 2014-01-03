//
//  AssetLibraryMultiSelect
//
//  Copyright (c) 2013 Alexander Belliotti. All rights reserved.
//

#import "ADBHelpers.h"

#import <AssetsLibrary/AssetsLibrary.h>

#import "ADBAppDelegate.h"

#import "NSString+ADBUtil.h"

void throwAbstractException(NSString *className, NSString *methodName) {
    [NSException raise:@"ADBAbstractException"
                format:@"%@ is an abstract class. Implement %@ in subclass.", className, methodName];
}

BOOL ADBIsTablet() {
    return ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad);
}

BOOL ADBIsStringWithText(id object) {
    if (![object isKindOfClass:[NSString class]] || [object isEqual:[NSNull null]]) return NO;
    
    NSString *trimmed = [object trimmedString];
    return [trimmed length] > 0;
}

BOOL ADBIsCollectionWithObjects(id object) {
    
    if ([object isKindOfClass:[NSArray class]] ||
        [object isKindOfClass:[NSDictionary class]] ||
        [object isKindOfClass:[NSSet class]] ||
        [object isKindOfClass:[NSOrderedSet class]])
    {
        return ([object count] > 0);
    } else {
        return NO;
    }
}

NSString* ADBCoalesceString(NSString *string) {
    NSString *toReturn = nil;
    toReturn = ADBIsStringWithText(string) ? string : @"";
    return toReturn;
}

BOOL isAccessError(NSError *error) {
    if ([error.domain isEqualToString:ALAssetsLibraryErrorDomain] && [error code] == -3311) {
        return YES;
    } else {
        return NO;
    }
}

UIAlertView* ADBPopup(NSString *title, NSString *message) {
    UIAlertView *alertView = ADBPopupDismiss(title, message, @"Dismiss");
    return alertView;
}

UIAlertView* ADBPopupDismiss(NSString *title, NSString *message, NSString *dismissTitle) {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:dismissTitle
                                              otherButtonTitles:nil];
    return alertView;
}

UIAlertView* ADBLibraryAccessDeniedPopup() {
    return ADBPopup(@"Photo Library Access Needed",
                    @"This app needs access to your photos to function.\nTo grant access, go to Settings -> Privacy.");
}

ALAssetsLibrary* assetsLibrary() {
    ADBAppDelegate *appDelegate = [ADBHelpers app];
    return appDelegate.assetsLibrary;
}

CGFloat distanceBetweenPoints(CGPoint a, CGPoint b) {
    CGFloat xComponent = powf(b.x - a.x, 2.f);
    CGFloat yComponent = powf(b.y - a.y, 2.f);
    
    return (sqrtf(xComponent + yComponent));
}

CGRect logRect(CGRect rect) {
    NSLog(@"X:%f Y:%f Width:%f Height:%f",
          CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetWidth(rect), CGRectGetHeight(rect));
    return rect;
}

@implementation ADBHelpers

+ (ADBAppDelegate *)app {
    return (ADBAppDelegate *)[[UIApplication sharedApplication] delegate];
}

@end
