//
//  AssetLibraryMultiSelect
//
//  Copyright (c) 2013 Alexander Belliotti. All rights reserved.
//

#import "ADBMediaDetailDataSource.h"

#import "ADBAssetItem.h"

#import "NIPagingScrollView.h"
#import "NIPhotoScrollView.h"
#import "ADBMovieScrollView.h"

#import "ADBMediaDetailController.h"

@interface ADBMediaDetailDataSource () 

@property (nonatomic) NSCache *imageCache;

@end

@implementation ADBMediaDetailDataSource

- (id)init {
    self = [super init];
    if (self) {
        _imageCache = [[NSCache alloc] init];
        _imageCache.name = @"detail_images";
        _imageCache.countLimit = 3;
    }
    
    return self;
}

- (id)initWithItems:(NSArray *)items {
    self = [self init];
    if (self) {
        _items = items;
    }
    
    return self;
}

-(void)dealloc {
    [self.imageCache removeAllObjects];
}

#pragma mark -
#pragma mark ADBMediaDetailDataSource

- (void)loadImageForIndex:(NSInteger)index {
    __weak ADBMediaDetailDataSource *selfRef = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        UIImage *image = [selfRef.items[(NSUInteger)index] detailImage];
        [selfRef.imageCache setObject:image
                               forKey:@(index)];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [selfRef.controller.photoAlbumView didLoadPhoto:image
                                                    atIndex:index
                                                  photoSize:NIPhotoScrollViewPhotoSizeOriginal];
        });
    });
}

#pragma mark -
#pragma mark NIPhotoAlbumScrollViewDataSource

- (UIImage *)photoAlbumScrollView: (NIPhotoAlbumScrollView *)photoAlbumScrollView
                     photoAtIndex: (NSInteger)photoIndex
                        photoSize: (NIPhotoScrollViewPhotoSize *)photoSize
                        isLoading: (BOOL *)isLoading
          originalPhotoDimensions: (CGSize *)originalPhotoDimensions
{
    UIImage *image = [self.imageCache objectForKey:@(photoIndex)];
    if (!!image) {
        *photoSize = NIPhotoScrollViewPhotoSizeOriginal;
        *originalPhotoDimensions = image.size;
        
        return image;
    } else {
        *photoSize = NIPhotoScrollViewPhotoSizeUnknown;
        *isLoading = YES;
        [self loadImageForIndex:photoIndex];
        return nil;
    }
}

#pragma mark NIPagingScrollViewDataSource

- (NSInteger)numberOfPagesInPagingScrollView:(NIPagingScrollView *)pagingScrollView {
    return (NSInteger) self.items.count;
}

- (UIView<NIPagingScrollViewPage> *)pagingScrollView:(NIPagingScrollView *)pagingScrollView pageViewForIndex:(NSInteger)pageIndex {
    ADBAssetItem *item = [self.items objectAtIndex:pageIndex];
    BOOL isVideo = item.type == ADBAssetTypeVideo;
    
    if (!isVideo) {
        //photo
        NIPhotoScrollView *photoView = nil;
        [pagingScrollView dequeueReusablePageWithIdentifier:@"photo"];
        if (!photoView) {
            photoView = [[NIPhotoScrollView alloc] initWithFrame:self.controller.navigationController.view.frame];
            photoView.reuseIdentifier = @"photo";
        }
       
        photoView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        return photoView;
    } else {
        //video
        ADBMovieScrollView *movieView = nil;
        [pagingScrollView dequeueReusablePageWithIdentifier:@"movie"];
        if (!movieView) {
            movieView = [[ADBMovieScrollView alloc] initWithFrame:self.controller.navigationController.view.frame
                                                 detailController:self.controller];
            movieView.reuseIdentifier = @"movie";
        }
        
        movieView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        return movieView;
    }
}

#pragma mark - NIPhotoScrubberViewDataSource

- (NSInteger)numberOfPhotosInScrubberView:(NIPhotoScrubberView *)photoScrubberView {
    return self.items.count;
}

- (UIImage *)photoScrubberView:(NIPhotoScrubberView *)photoScrubberView thumbnailAtIndex:(NSInteger)thumbnailIndex {
    ADBAssetItem *item = [self.items objectAtIndex:(NSUInteger)thumbnailIndex];
    return item.thumbImage;
}

@end
