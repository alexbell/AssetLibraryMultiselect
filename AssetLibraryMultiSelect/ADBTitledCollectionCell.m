//
//  AssetLibraryMultiSelect
//
//  Copyright (c) 2013 Alexander Belliotti. All rights reserved.
//

#import "ADBTitledCollectionCell.h"

#import "ADBViewConstants.h"

@interface ADBTitledCollectionCell ()

- (void)addCountLabel;
- (void)removeCountLabel;

@end

@implementation ADBTitledCollectionCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f,
                                                                frame.size.width - 10.f, 18.f)];
        _titleLabel.font = [UIFont systemFontOfSize:kFontSizeSmall];
        _titleLabel.textColor = [UIColor darkTextColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 2;
        [self.contentView addSubview:_titleLabel];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.thumbView.frame = CGRectMake(CGRectGetMinX(self.thumbView.frame), 0.f,
                                      CGRectGetWidth(self.thumbView.frame), CGRectGetHeight(self.thumbView.frame));
    
    self.titleLabel.center = self.center;
    self.titleLabel.frame = CGRectMake(5.f, CGRectGetMaxY(self.thumbView.frame) + 5.f,
                                       CGRectGetWidth(self.frame) - 10.f, 18.f);
    
    self.selectedCountLabel.frame =
    CGRectMake(CGRectGetMinX(self.thumbView.frame) + 1.f,
               (CGRectGetHeight(self.thumbView.frame) / 2.f) - (CGRectGetHeight(self.selectedCountLabel.frame) / 2.f),
               CGRectGetWidth(self.thumbView.frame) - 2.f,
               30.f);
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.titleLabel.text = @"";
    [self removeCountLabel];
}

- (void)setSelectedCount:(NSUInteger)count {
    /*
    if (!self.selectedCountLabel && count > 0) {
        [self addCountLabel];
    } else if (self.selectedCountLabel && count == 0) {
        [self removeCountLabel];
        return;
    }
    
    NSString *item = (count > 1) ? @"items" : @"item";
    self.selectedCountLabel.text = [NSString stringWithFormat:@"%lu %@ selected", (unsigned long)count, item];
    [self setNeedsLayout];
     */
}

#pragma mark Private

- (void)addCountLabel {
    _selectedCountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _selectedCountLabel.font = [UIFont boldSystemFontOfSize:kFontSizeSmall];
    _selectedCountLabel.textAlignment = NSTextAlignmentCenter;
    _selectedCountLabel.numberOfLines = 2;
    _selectedCountLabel.frame = CGRectMake(1.f, 0.f,
                                           CGRectGetWidth(self.contentView.frame) - 1.f, 30.f);
    _selectedCountLabel.backgroundColor = [UIColor clearColor];
    
    [self.contentView addSubview:self.selectedCountLabel];
}

- (void)removeCountLabel {
    [self.selectedCountLabel removeFromSuperview];
    _selectedCountLabel = nil;
}

@end
