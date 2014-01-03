//
//  AssetLibraryMultiSelect
//
//  Copyright (c) 2013 Alexander Belliotti. All rights reserved.
//

#import "ADBCollectionViewController.h"

@class ADBDataSource;
@class ADBGroupItem;

@interface ADBMediaSelectController : ADBCollectionViewController

@property (nonatomic) ADBDataSource *dataSource;

- (id)initWithGroup:(ADBGroupItem *)group;

@end
