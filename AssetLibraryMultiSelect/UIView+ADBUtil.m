//
//  UIView+ADBUtil.m
//
//  Copyright (c) 2013 Alexander Belliotti. All rights reserved.
//

#import "UIView+ADBUtil.h"

@implementation UIView (ADBUtil)

- (UIView *)firstSuperviewOfClass:(Class)theClass {
    UIView *next = [self superview];
    
    if (!next) return nil;
    else if ([next isKindOfClass:theClass]) {
        return next;
    } else {
        return [next firstSuperviewOfClass:theClass];
    }
}

@end
