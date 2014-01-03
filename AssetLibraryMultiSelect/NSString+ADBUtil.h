//
//  AssetLibraryMultiSelect
//
//  Copyright (c) 2013 Alexander Belliotti. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ADBUtil)

- (BOOL)containsString:(NSString *)str caseSensitive:(BOOL)caseSensitive;
- (BOOL)containsString:(NSString *)str;

- (NSString *)trimmedString;

@end
