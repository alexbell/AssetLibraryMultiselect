//
//  AssetLibraryMultiSelect
//
//  Copyright (c) 2013 Alexander Belliotti. All rights reserved.
//

#import "ADBMediaDetailController.h"

#import <MediaPlayer/MediaPlayer.h>

#import "ADBAssetItem.h"
#import "ADBMediaDetailDataSource.h"
#import "ADBAssetStore.h"

#import "NIPhotoScrollView.h"

//misc
#import "ADBHelpers.h"

const NSInteger kBarItemTagAdd = 150;
const NSInteger kBarItemTagRemove = 300;
const NSInteger kBarItemTagCustomized = 111;

@interface NIToolbarPhotoViewController (InheritedPrivate)

- (void)updateToolbarItems;

@end

@interface ADBMediaDetailController () {
    @protected
    NSInteger _initialIndex;
    @private
    BOOL _firstLoadCompleted;
}

@property (nonatomic, weak) MPMoviePlayerController *movieController;

//notifications
- (void)receivedAssetStoreCountUpdate:(NSNotification *)notif;

@end

@implementation ADBMediaDetailController

- (id)initWithSelectedItem:(ADBAssetItem *)item inItems:(NSArray *)items {
    self = [super init];
    if (self) {
        NSUInteger centerIndex = [items indexOfObject:item];
        _dataSource = [[ADBMediaDetailDataSource alloc] initWithItems:items];
        _dataSource.controller = self;
        _initialIndex = centerIndex;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receivedAssetStoreCountUpdate:)
                                                     name:kNotificationSendAssetsUpdated
                                                   object:nil];
    }
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSString *)title {
    NSString *selectedTitle = [[ADBAssetStore instance] selectedTitleString];
    return selectedTitle;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    self.toolbarIsTranslucent = YES;
    self.photoAlbumView.photoViewBackgroundColor = [UIColor whiteColor];
    self.photoAlbumView.dataSource = self.dataSource;
    
    [self.photoAlbumView reloadData];
    
    self.photoScrubberView.dataSource = self.dataSource;
    [self.photoScrubberView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.toolbar.barStyle = UIBarStyleDefault;
    self.toolbar.translucent = YES;
    self.toolbar.barTintColor = [UIColor blueColor];
    self.toolbar.tintColor = [UIColor whiteColor];
    
    //FIXME: if this is called in viewDidLoad in landscape
    //rotation breaks because the the page frames are calculated incorrectly
    //thus, we have to maintain state whether it's the controller's first load
    if (!_firstLoadCompleted) {
        [self.photoAlbumView moveToPageAtIndex:_initialIndex animated:NO];
        [self.photoScrubberView setSelectedPhotoIndex:_initialIndex animated:NO];
        _firstLoadCompleted = YES;
    } else {
        //this catches the above rotation bug, but moves us to last index rather than initial
        //eg, play movie, rotate to landscape, go back to detail controller
        [self.photoAlbumView moveToPageAtIndex:self.photoAlbumView.centerPageIndex animated:NO];
    }
}

#pragma mark -
#pragma mark ADBMediaDetailController

- (ADBAssetItem *)currentCenterItem {
    NSUInteger centerIndex = (NSUInteger) self.photoAlbumView.centerPageIndex;
    return self.dataSource.items[centerIndex];
}

- (void)movieOverlayTapped {
    ADBAssetItem *currentItem = self.currentCenterItem;
    NSURL *itemUrl = currentItem.defaultAssetURL;
    if (currentItem.type != ADBAssetTypeVideo || !itemUrl) return;
    
    //apple framework bug?
    //http://stackoverflow.com/questions/13203336/iphone-mpmovieplayerviewcontroller-cgcontext-errors/14669166#14669166
    //fake graphics context prevents errors
    UIGraphicsBeginImageContext(CGSizeMake(1.f, 1.f));
    MPMoviePlayerViewController *movieController = [[MPMoviePlayerViewController alloc] initWithContentURL:itemUrl];
    self.movieController = movieController.moviePlayer;
    UIGraphicsEndImageContext();
    
    [movieController.moviePlayer prepareToPlay];
    [self presentMoviePlayerViewControllerAnimated:movieController];
}

#pragma mark Notifications

- (void)receivedAssetStoreCountUpdate:(NSNotification *)notif {
    //assets added or removed, change title
    self.title = self.title;
}

#pragma mark - NIPhotoScrubberViewDelegate

- (void)photoScrubberViewDidChangeSelection:(NIPhotoScrubberView *)photoScrubberView {
    NSInteger selectedIndex = photoScrubberView.selectedPhotoIndex;
    [self.photoAlbumView moveToPageAtIndex:selectedIndex animated:YES];
}

@end

