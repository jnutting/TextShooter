//
//  BIDViewController.m
//  TextShooter
//
//  Created by JN on 2013-12-6.
//  Copyright (c) 2013 Apress. All rights reserved.
//

#import "BIDViewController.h"
#import "BIDLevelScene.h"
#import "BIDStartScene.h"
#import "RBSGameCenterManager.h"

@implementation BIDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
//    skView.showsFPS = YES;
//    skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    SKScene * scene = [BIDStartScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    [self authenticateLocalPlayer];
    
    // Present the scene.
    [skView presentScene:scene];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)authenticateLocalPlayer {
    RBSGameCenterManager *gcm =[RBSGameCenterManager shared];
    gcm.shouldShowAuthenticationDialogImmediately = ^BOOL(void) {
        SKView *skView = (SKView *)self.view;
        return [skView.scene isKindOfClass:[BIDStartScene class]];
    };
    [gcm authenticateLocalPlayer:^(BOOL success) {
        SKView *skView = (SKView *)self.view;
        BIDStartScene *startScene = [skView.scene isKindOfClass:[BIDStartScene class]] ? (id)skView.scene : nil;
        if (success) {
//            NSLog(@"playerAuthenticated %@", [GKLocalPlayer localPlayer]);
            startScene.gameCenterButtonEnabled = YES;
        } else {
//            NSLog(@"disableGameCenter");
            startScene.gameCenterButtonEnabled = NO;
        }
    }];
}

@end
