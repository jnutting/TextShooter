//
//  RBSGameCenterManager.m
//  FlippyBit
//
//  Created by JN on 2014-2-21.
//  Copyright (c) 2014 Rebisoft. All rights reserved.
//

#import <GameKit/GameKit.h>
#import "RBSGameCenterManager.h"

@interface RBSGameCenterManager () <GKGameCenterControllerDelegate>

@property (strong, nonatomic) UIViewController *pendingAuthenticationDialog;
@property (assign, nonatomic) BOOL hasShownAuthenticationDialog;

// The authenticationHandler is called after authentication is done. Use this
// to adjust GUI based on whether or not the user is authenticated.
@property (copy, nonatomic) void(^authenticationHandler)(BOOL success);
@property (copy, nonatomic) void(^gameCenterViewControllerCompletion)(void);


@end

@implementation RBSGameCenterManager

// Grab the singleton.
+ (instancetype)shared {
    static id shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (id)init {
    if (!(self = [super init])) return nil;
    
    _presentingViewController = [[[[UIApplication sharedApplication] windows] firstObject] rootViewController];
    
    return self;
}

// Authenticate once at game launch
- (void) authenticateLocalPlayer:(void(^)(BOOL success))authenticationHandler {
    self.authenticationHandler = authenticationHandler;
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
        if (viewController)
        {
            self.pendingAuthenticationDialog = viewController;
            if (self.shouldShowAuthenticationDialogImmediately && self.shouldShowAuthenticationDialogImmediately()) {
                [self showAuthenticationImmediately];
            }
        }
        else if (self.authenticationHandler) {
            self.authenticationHandler([GKLocalPlayer localPlayer].isAuthenticated);
        }
    };
}

// Call this every time your app enters a state where the authentication dialog
// can reasonably be shown. The dialog will only ever be shown once. Returns
// YES if it shows the dialog.
- (BOOL)showAuthenticationDialogIfNeeded {
    if (self.pendingAuthenticationDialog && !self.hasShownAuthenticationDialog) {
        [self showAuthenticationImmediately];
        return YES;
    }
    return NO;
}

// Shows the game center view. Don't call this if the local player isn't
// authenticated.
- (void)showGameCenterWithInitialViewState:(GKGameCenterViewControllerState)viewState
                     leaderboardIdentifier:(NSString *)leaderboardIdentifier
                         completionHandler:(void (^)())completion {
    self.gameCenterViewControllerCompletion = completion;
    GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
    if (gameCenterController != nil)
    {
        gameCenterController.gameCenterDelegate = self;
        gameCenterController.viewState = GKGameCenterViewControllerStateLeaderboards;
        gameCenterController.viewState = viewState;
        if (leaderboardIdentifier) {
            gameCenterController.leaderboardIdentifier = leaderboardIdentifier;
        }
        
        UINavigationController *navCon = (id)[[[[UIApplication sharedApplication] windows] firstObject] rootViewController];
        [navCon presentViewController: gameCenterController animated: YES completion:nil];
    }
}

- (void)showAuthenticationImmediately {
    if (self.hasShownAuthenticationDialog) return;
    [self.presentingViewController presentViewController:self.pendingAuthenticationDialog
                                                animated:YES
                                              completion:nil];
    self.hasShownAuthenticationDialog = YES;
}

// delegate method called after game center is closed
- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    if (self.gameCenterViewControllerCompletion) {
        self.gameCenterViewControllerCompletion();
    }
}

@end
