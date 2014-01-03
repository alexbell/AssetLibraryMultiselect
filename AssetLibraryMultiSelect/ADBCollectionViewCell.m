//
//  AssetLibraryMultiSelect
//
//  Copyright (c) 2013 Alexander Belliotti. All rights reserved.
//

#import "ADBCollectionViewCell.h"


@interface ADBCollectionViewCell ()

- (CGPoint)movieLabelCenter;
- (NSString *)movieLengthString:(NSUInteger)secondsLength;

@end

@implementation ADBCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _thumbView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, 75.f, 75.f)];
        _thumbView.center = self.contentView.center;
        _thumbView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_thumbView];
    }
    
    return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];

	self.thumbView.center = self.contentView.center;
    
    if (self.movieView) {
        self.movieView.center = self.contentView.center;
    }
    
    if (self.movieLabel) {
        self.movieLabel.center = [self movieLabelCenter];
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.thumbView.image = nil;
    [self removeMovieOverlay];
}

#pragma mark - ADBCollectionViewCell

- (void)addMovieOverlay:(NSUInteger)movieLength {
    if (!self.movieView) {
        UIImage *movieImage = [[UIImage imageNamed:@"film"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.movieView = [[UIImageView alloc] initWithImage:movieImage];
        self.movieView.tintColor = [UIColor blueColor];
        self.movieView.frame = CGRectMake(0.f, 0.f, 20.f, 20.f);
        self.movieView.backgroundColor = [UIColor clearColor];
        self.movieView.center = self.contentView.center;
        self.movieView.userInteractionEnabled = NO;
        
        if (movieLength > 0) {
            self.movieLabel = [[UILabel alloc] init];
            self.movieLabel.numberOfLines = 1;
            self.movieLabel.backgroundColor = [UIColor clearColor];
            self.movieLabel.font = [UIFont systemFontOfSize:8.f];
            self.movieLabel.textColor = [UIColor blueColor];
            self.movieLabel.center = [self movieLabelCenter];
            self.movieLabel.text = [self movieLengthString:movieLength];
            self.movieLabel.userInteractionEnabled = NO;
            [self.movieLabel sizeToFit];
            
            [self addSubview:self.movieLabel];
        }
        
        [self addSubview:self.movieView];
    }
}

- (void)removeMovieOverlay {
    [self.movieView removeFromSuperview];
    self.movieView = nil;
    
    [self.movieLabel removeFromSuperview];
    self.movieLabel = nil;
}

#pragma mark Private

- (CGPoint)movieLabelCenter {
    CGFloat labelX = self.contentView.frame.size.width * .5f;
    CGFloat labelY = self.movieView.frame.origin.y + self.movieView.frame.size.height + 7.f;
    return CGPointMake(labelX, labelY);
}

- (NSString *)movieLengthString:(NSUInteger)secondsLength {
    NSString *minutesStr = nil;
    NSString *secondsStr = nil;
    
    if (secondsLength < 60) {
        minutesStr = @"0";
    } else {
        minutesStr = [NSString stringWithFormat:@"%lu", (unsigned long)(secondsLength / 60)];
    }
    
    NSUInteger rightSide = secondsLength % 60u;
    if (rightSide < 10u) {
        secondsStr = [NSString stringWithFormat:@"0%lu", (unsigned long)rightSide];
    } else {
        secondsStr = [NSString stringWithFormat:@"%lu", (unsigned long)rightSide];
    }
    
    return [NSString stringWithFormat:@"%@:%@", minutesStr, secondsStr];
}

@end
