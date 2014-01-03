//
//  AssetLibraryMultiSelect
//
//  Copyright (c) 2013 Alexander Belliotti. All rights reserved.
//

#import "ADBGridGroupSelectController.h"

#import "ADBAssetLibraryItem.h"
#import "ADBDataSource.h"
#import "ADBGridGroupSelectDataSource.h"
#import "ADBAssetStore.h"
#import "ADBGroupItem.h"

#import "ADBTitledCollectionCell.h"

#import "ADBMediaSelectController.h"

#import "ADBHelpers.h"

const CGFloat kMinItemSpacing = 5.0f;
const CGFloat kMinLineSpacing = 5.0f;

@interface ADBGridGroupSelectController ()

//notifications
- (void)receivedAssetStoreCountUpdate:(NSNotificationCenter *)notif;

@end

@implementation ADBGridGroupSelectController

#pragma mark -
#pragma mark ADBCollectionViewController

- (id)init {
    self = [super init];
    if (self) {
        _dataSource = [[ADBGridGroupSelectDataSource alloc] init];
        _dataSource.controller = self;
        
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

- (UICollectionViewFlowLayout *)layout {
    UICollectionViewFlowLayout *layout = [super layout];
    layout.minimumInteritemSpacing = 4.f;
    layout.minimumLineSpacing = 5.f;
    layout.sectionInset = UIEdgeInsetsMake(4.f, 4.f, 0.f, 4.f);
    layout.itemSize = CGSizeMake(85.f, 105.f);
    
    return layout;
}

- (NSString *)title {
    NSString *titleString = [[ADBAssetStore instance] selectedTitleString];
    if (!titleString) {
        titleString = @"Albums";
    }
    
    return titleString;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    
    //self.dataSource.delegate = self;
    self.collectionView.dataSource = self.dataSource;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.dataSource load];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ADBGridGroupSelectController

+ (NSString *)reuseIDString {
    return @"groupSelect";
}

+ (Class)cellClass {
    return [ADBTitledCollectionCell class];
}

#pragma mark Notifications

- (void)receivedAssetStoreCountUpdate:(NSNotificationCenter *)notif {
    self.title = self.title;
    
}

#pragma mark -
#pragma mark ADBThumbLoaderDelegate

- (void)dataSource:(ADBDataSource *)dataSource loadedThumbForIndexPath:(NSIndexPath *)indexPath {
    [self.collectionView insertItemsAtIndexPaths:@[ indexPath ]];
}

- (void)dataSource:(ADBDataSource *)dataSource loadedThumbsForIndexPaths:(NSArray *)indexPaths {
    [self.collectionView insertItemsAtIndexPaths:indexPaths];
}

- (void)dataSource:(ADBDataSource *)dataSource reloadedThumbForIndexPath:(NSIndexPath *)indexPath {
    ADBGroupItem *item = [self.dataSource itemAtIndexPath:indexPath];
    if (item) {
        [self.dataSource syncCountForGroupItem:item];
    }
    
    [self.collectionView reloadItemsAtIndexPaths:@[ indexPath ]];
}

- (void)dataSource:(ADBDataSource *)dataSource reloadedThumbForIndexPaths:(NSArray *)indexPaths {
    for (NSIndexPath *indexPath in indexPaths) {
        ADBGroupItem *item = [self.dataSource itemAtIndexPath:indexPath];
        if (item) {
            [self.dataSource syncCountForGroupItem:item];
        }
    }
    
    [self.collectionView reloadItemsAtIndexPaths:indexPaths];
}

- (void)dataSource:(ADBDataSource *)dataSource encounteredError:(NSError *)error {
    if (isAccessError(error)) {
        [ADBLibraryAccessDeniedPopup() show];
    }
}

#pragma mark - 
#pragma mark ADBCollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ADBGroupItem *item = [self.dataSource itemAtIndexPath:indexPath];
    assert(item != nil);
    ADBMediaSelectController *selectController = [[ADBMediaSelectController alloc] initWithGroup:item];
    [self.navigationController pushViewController:selectController animated:YES];
}

- (void)collectionView:(ADBCollectionView *)collectionView didLongPressItemAtIndexPath:(NSIndexPath *)indexPath {
    ADBGroupItem *groupItem = [self.dataSource itemAtIndexPath:indexPath];
    if (!groupItem) return;
    
    [self.dataSource syncCountForGroupItem:groupItem];
    
    [self.dataSource toggleGroupItems:groupItem];
}

@end
