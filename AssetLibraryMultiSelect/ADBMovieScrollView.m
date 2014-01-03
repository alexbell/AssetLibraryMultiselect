//
//  AssetLibraryMultiSelect
//
//  Copyright (c) 2013 Alexander Belliotti. All rights reserved.
//

#import "ADBMovieScrollView.h"

#import "ADBPlayMovieOverlay.h"

#import "ADBMediaDetailController.h"

@implementation ADBMovieScrollView

- (id)initWithFrame:(CGRect)frame detailController:(ADBMediaDetailController *)controller {
    self = [super initWithFrame:frame];
    if (self) {
        _overlay = [[ADBPlayMovieOverlay alloc] initWithFrame:CGRectMake(0.f, 0.f, 70.f, 70.f)];
        _overlay.center = self.center;
        
        UIGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:controller action:@selector(movieOverlayTapped)];
        [self.overlay addGestureRecognizer:tapRecognizer];
        [self addSubview:_overlay];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _overlay.center = CGPointMake(self.frame.size.width / 2.f, self.frame.size.height / 2.f);
}

@end
