//
//  AssetLibraryMultiSelect
//
//  Copyright (c) 2013 Alexander Belliotti. All rights reserved.
//

#import "ADBMediaSelectController.h"

#import "ADBDataSource.h"
#import "ADBMediaSelectDataSource.h"
#import "ADBGroupItem.h"
#import "ADBAssetItem.h"
#import "ADBAssetStore.h"

#import "ADBSelectCollectionCell.h"

#import "ADBMediaDetailController.h"

#import "ADBHelpers.h"

@interface ADBMediaSelectController ()

//notifications
- (void)receivedAssetStoreCountUpdate:(NSNotification *)notif;

@end

@implementation ADBMediaSelectController

- (id)initWithGroup:(ADBGroupItem *)group {
    self = [super init];
    if (self) {
        _dataSource = [[ADBMediaSelectDataSource alloc] initWithGroupItem:group sortOrder:ADBSortRecentFirst];
        
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    self.collectionView.allowsSelection = YES;
    self.collectionView.allowsMultipleSelection = YES;
    
    ADBMediaSelectDataSource *dataSource = (ADBMediaSelectDataSource *)self.dataSource;
    self.collectionView.dataSource = dataSource;
    dataSource.controller = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    [self.navigationController setNavigationBarHidden:NO];
    
    self.title = self.title;
    
    
    [self.dataSource removeAllItems];
    [self.collectionView reloadData];
    [self.dataSource load];
   
    //we need to mark the items in the store as selected, so the collection view knows the appropriate state
    NSArray *selectedItems = [[ADBAssetStore instance] assetItems];
    if (ADBIsCollectionWithObjects(selectedItems)) {
        NSArray *items = [self.dataSource items];
        [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            ADBAssetItem *item = obj;
            if ([selectedItems containsObject:item]) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:(NSInteger)idx inSection:0];
                [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            }
        }];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    self.title = self.title;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)title {
    NSString *selectedString = [[ADBAssetStore instance] selectedTitleString];
    if (selectedString && self.navigationController.topViewController == self) {
        return selectedString;
    } else {
        ADBMediaSelectDataSource *dataSource = (ADBMediaSelectDataSource *)self.dataSource;
        return dataSource.group.groupName;
    }
}

#pragma mark -
#pragma mark ADBCollectionViewController

- (UICollectionViewFlowLayout *)layout {
    UICollectionViewFlowLayout *layout = [super layout];
    layout.minimumInteritemSpacing = 4.f;
    layout.minimumLineSpacing = 5.f;
    
    return layout;
}

+ (Class)cellClass {
    return [ADBSelectCollectionCell class];
}

+ (NSString *)reuseIDString {
    return @"reuseMe";
}

#pragma mark - ADBMediaSelectController

#pragma mark Notifications

- (void)receivedAssetStoreCountUpdate:(NSNotification *)notif {
    self.title = self.title;
    
    BOOL isTopController = self.navigationController.topViewController == self;
    //the select/deselect delegate methods will do the work if the controller is up
    if (isTopController) { return; }
    
    ADBAssetItem *touchedItem = notif.userInfo[kKeyTouchedItem];
    
    NSArray *visibleCells = [self.collectionView visibleCells];
    for (ADBSelectCollectionCell *cell in visibleCells) {
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
        ADBAssetItem *item = [self.dataSource itemAtIndexPath:indexPath];
        
        if ([item isEqual:touchedItem]) {
            BOOL isSelected = [notif.userInfo[kKeyAddedOrRemoved] boolValue];
            
            if (isSelected) {
                [self.collectionView selectItemAtIndexPath:indexPath
                                                  animated:NO
                                            scrollPosition:UICollectionViewScrollPositionNone];
            } else {
                [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
            }
        }
    }
}

#pragma mark -
#pragma mark UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(75.f, 75.f);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(2.f, 2.f, 0.f, 2.f);
}

#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ADBAssetItem *item = [self.dataSource itemAtIndexPath:indexPath];
    [[ADBAssetStore instance] addAssetItem:item];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    ADBAssetItem *item = [self.dataSource itemAtIndexPath:indexPath];
    [[ADBAssetStore instance] removeAssetItem:item];
}

#pragma mark ADBCollectionViewDelegate

- (void)collectionView:(ADBCollectionView *)collectionView didLongPressItemAtIndexPath:(NSIndexPath *)indexPath {
    ADBAssetItem *item = [self.dataSource itemAtIndexPath:indexPath];
    
    ADBMediaDetailController *detailController =
    [[ADBMediaDetailController alloc] initWithSelectedItem:item inItems:self.dataSource.items];
    detailController.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:detailController animated:YES];
}

#pragma mark - ADBAssetReaderDelegate

- (void)assetStore:(ADBAssetStore *)store hasNewCount:(NSNumber *)count {
    self.title = self.title;
}

@end
