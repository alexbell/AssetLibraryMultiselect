//
//  AssetLibraryMultiSelect
//
//  Copyright (c) 2013 Alexander Belliotti. All rights reserved.
//

#import "ADBPlayMovieOverlay.h"

@implementation ADBPlayMovieOverlay

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
        
    CGPoint convertedCenter = [self convertPoint:self.center fromView:self.superview];

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    if (ctx == NULL) return;
   
    CGContextSetRGBFillColor(ctx, 89.f, 97.f, 102.f, .5f);
    CGContextAddArc(ctx, convertedCenter.x, convertedCenter.y, MIN(width / 2.f, height / 2.f), 0, 2 * M_PI, 1);
    CGContextFillPath(ctx);
    
    CGContextBeginPath(ctx);
    CGContextSetRGBFillColor(ctx, 255.f, 255.f, 255.f, .75f);
    CGContextMoveToPoint(ctx, width * .75f, height * .5f);
    CGPoint points[] = {CGPointMake(width * .25f, height * .25f), CGPointMake(width * .25f, height * .75f)};
    CGContextAddLineToPoint(ctx, points[0].x, points[0].y);
    CGContextAddLineToPoint(ctx, points[1].x, points[1].y);
    CGContextAddLineToPoint(ctx, width * .75, height * .5);
    CGContextClosePath(ctx);
    CGContextFillPath(ctx);
}

@end
