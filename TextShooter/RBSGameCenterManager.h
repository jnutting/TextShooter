//
//  RBSGameCenterManager.h
//  FlippyBit
//
//  Created by JN on 2014-2-21.
//  Copyright (c) 2014 Rebisoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>


@interface RBSGameCenterManager : NSObject

// Grab the singleton.
+ (instancetype)shared;

// Use this to specify the view controller that will show the authentication
// dialog and/or game center view controller. Defaults to
// [[[[UIApplication sharedApplication] windows] firstObject] rootViewController]
@property (weak, nonatomic) UIViewController *presentingViewController;

// Authenticate once at game launch
- (void) authenticateLocalPlayer:(void(^)(BOOL success))authenticationHandler;

// As soon as the authentication dialog is available, it will call this block
// to see if now is a good time to show the dialog. If not, it will wait and
// until showAuthenticationDialogIfNeeded is called.
@property (copy, nonatomic) BOOL(^shouldShowAuthenticationDialogImmediately)(void);

// Call this every time your app enters a state where the authentication dialog
// can reasonably be shown. The dialog will only ever be shown once. Returns
// YES if it shows the dialog.
- (BOOL)showAuthenticationDialogIfNeeded;

// Shows the game center view. Don't call this if the local player isn't
// authenticated.
- (void)showGameCenterWithInitialViewState:(GKGameCenterViewControllerState)viewState
                     leaderboardIdentifier:(NSString *)leaderboardIdentifier
                         completionHandler:(void (^)())completion;

@end
