//
//  AssetLibraryMultiSelect
//
//  Copyright (c) 2013 Alexander Belliotti. All rights reserved.
//

#import "ADBMoviePlayerController.h"

#import "ADBHelpers.h"

@interface ADBMoviePlayerController ()

//notifications
- (void)receivedAssetStoreCountUpdate:(NSNotification *)notif;
- (void)receivedMoviePlayerLeftFullScreen;
- (void)receivedMoviePlayerMovieEnded:(NSNotification *)notif;

@end

@implementation ADBMoviePlayerController

- (id)initWithContentURL:(NSURL *)contentURL {
	self =[super initWithContentURL:contentURL];
	if (self) {

	}

	return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.moviePlayer.movieSourceType = MPMovieSourceTypeFile;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedMoviePlayerLeftFullScreen)
                                                 name:MPMoviePlayerDidExitFullscreenNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedMoviePlayerMovieEnded:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ADBMoviePlayerController

#pragma mark Notifications

- (void)receivedAssetStoreCountUpdate:(NSNotification *)notif {
    self.title = self.title;
}

- (void)receivedMoviePlayerLeftFullScreen {
    
}

- (void)receivedMoviePlayerMovieEnded:(NSNotification *)notif {
    NSNumber *reason = notif.userInfo[MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    if (reason.integerValue == MPMovieFinishReasonUserExited) {
        [self.moviePlayer stop];
        [self.parentViewController dismissMoviePlayerViewControllerAnimated];
    } else if (reason.integerValue == MPMovieFinishReasonPlaybackError) {
        [self.moviePlayer stop];
        [self.parentViewController dismissViewControllerAnimated:YES
                                                      completion:^{
                                                          ADBPopup(@"Error Playing Video", @"Could not play this video.");
                                                      }];
    }
}

@end
