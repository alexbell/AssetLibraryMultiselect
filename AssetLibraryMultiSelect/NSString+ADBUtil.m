//
//  AssetLibraryMultiSelect
//
//  Copyright (c) 2013 Alexander Belliotti. All rights reserved.
//

#import "NSString+ADBUtil.h"

@implementation NSString (ADBUtil)

- (BOOL)containsString:(NSString *)str caseSensitive:(BOOL)caseSensitive {
    if (!str || str.length == 0) return NO;
    
    NSStringCompareOptions options = caseSensitive ? NSCaseInsensitiveSearch : 0;
    NSRange range = [self rangeOfString:str options:options];
    
    return (range.location != NSNotFound);
}

- (BOOL)containsString:(NSString *)str {
    return [self containsString:str caseSensitive:NO];
}

- (NSString *)trimmedString {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
