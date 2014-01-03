//
//  AssetLibraryMultiSelect
//
//  Copyright (c) 2013 Alexander Belliotti. All rights reserved.
//
#import "ADBCollectionView.h"

#import "UIView+ADBUtil.h"

@interface ADBCollectionView ()

- (void)longPressAction:(UIGestureRecognizer *)recognizer;

@end

@implementation ADBCollectionView

- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.allowsSelection = YES;
        self.allowsMultipleSelection = YES;
        
        UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                                 action:@selector(longPressAction:)];
        self.longPressRecognizer = recognizer;
        
        [self addGestureRecognizer:recognizer];
        
        for (UIGestureRecognizer *gestureRecognizer in self.gestureRecognizers) {
            if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]] && gestureRecognizer != self.longPressRecognizer) {
                [gestureRecognizer requireGestureRecognizerToFail:recognizer];
            }
        }
    }
    
    return self;
}

- (void)dealloc {
    [self removeGestureRecognizer:self.longPressRecognizer];
}

#pragma mark -
#pragma mark Target/action long press

- (void)longPressAction:(UIGestureRecognizer *)recognizer {
    if ([self.delegate conformsToProtocol:@protocol(ADBCollectionViewDelegate)]) {
        CGPoint point = [recognizer locationInView:self];
        UICollectionViewCell *tappedCell = (UICollectionViewCell *) [[self hitTest:point withEvent:nil] firstSuperviewOfClass:[UICollectionViewCell class]];
        if (recognizer.state == UIGestureRecognizerStateBegan) {
            NSIndexPath *indexPath = [self indexPathForCell:tappedCell];
            if (!indexPath) return;
            if ([((id<ADBCollectionViewDelegate>)self.delegate) collectionView:self shouldLongPressItemAtIndexPath:indexPath]) {
                [((id<ADBCollectionViewDelegate>)self.delegate) collectionView:self didLongPressItemAtIndexPath:[self indexPathForCell:tappedCell]];
            }
        }
    }
}

@end
