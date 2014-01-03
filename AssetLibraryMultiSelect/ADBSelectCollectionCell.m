//
//  AssetLibraryMultiSelect
//
//  Copyright (c) 2013 Alexander Belliotti. All rights reserved.
//

#import "ADBSelectCollectionCell.h"

@interface ADBSelectCollectionCell ()

@property (nonatomic) UIImageView *checkmarkView;

- (void)setupCircleLayerForCheckmarkView:(UIImageView *)checkmarkView;

@end

CGPoint checkmarkCenter(UIView *contentView) {
    CGFloat checkmarkX = contentView.frame.size.width * 0.85f;
    CGFloat checkmarkY = contentView.frame.size.height * 0.85f;
    return CGPointMake(checkmarkX, checkmarkY);
}

@implementation ADBSelectCollectionCell

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.checkmarkView.center = checkmarkCenter(self.contentView);
}

- (void)setSelected:(BOOL)selected {
	[super setSelected:selected];
    
    @synchronized(self.checkmarkView) {
        if (selected && !self.checkmarkView) {
            [self addCheckmark];
        } else if (!selected) {
            [self removeCheckmark];
        }
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    [self removeCheckmark];
}

- (void)addCheckmark {
    if (!self.checkmarkView) {
        self.contentView.clipsToBounds = YES;
        
        UIImage *checkmarkImage = [[UIImage imageNamed:@"checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.checkmarkView = [[UIImageView alloc] initWithImage:checkmarkImage];
        [self setupCircleLayerForCheckmarkView:self.checkmarkView];
        
        self.checkmarkView.tintColor = [UIColor blueColor];
        self.checkmarkView.userInteractionEnabled = NO;
        self.checkmarkView.center = checkmarkCenter(self.contentView);
        [self.contentView addSubview:self.checkmarkView];
    }
}

- (void)removeCheckmark {
    [self.checkmarkView removeFromSuperview];
    self.checkmarkView = nil;
}

- (void)setupCircleLayerForCheckmarkView:(UIImageView *)checkmarkView {
    CGMutablePathRef circlePathRef = CGPathCreateMutable();
    
    CGPathAddArc(circlePathRef,
                 NULL,
                 self.checkmarkView.center.x,
                 self.checkmarkView.center.y,
                 CGRectGetHeight(checkmarkView.frame) - 5.f,
                 0,
                 2 * M_PI,
                 false);
    CGPathCloseSubpath(circlePathRef);
    
    CAShapeLayer *circleLayer = [[CAShapeLayer alloc] init];
    circleLayer.lineWidth = 2.f;
    circleLayer.fillRule = kCAFillRuleEvenOdd;
    circleLayer.path = circlePathRef;
    CGColorRef strokeColor = [[UIColor whiteColor] CGColor];
    circleLayer.strokeColor = strokeColor;
    circleLayer.fillColor = [[UIColor clearColor] CGColor];
    
    [checkmarkView.layer addSublayer:circleLayer];
    
    CFRelease(circlePathRef);
}

@end
