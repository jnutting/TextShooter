//
//  BIDStartScene.m
//  TextShooter
//
//  Created by JN on 2014-1-23.
//  Copyright (c) 2014 Apress. All rights reserved.
//

#import "BIDStartScene.h"
#import "BIDLevelScene.h"
#import "BIDHelpScene.h"
#import "BIDInfoScene.h"
#import "BIDGeometry.h"
#import <StoreKit/StoreKit.h>
#import "RBSGameCenterManager.h"
#import "SKNode+Extra.h"
#import <MultiProductViewer/TBTMultiProductViewController.h>
#import <MultiProductViewer/TBTProductCluster.h>

static SKAction *gameStartSound;

@interface BIDStartScene () <SKStoreProductViewControllerDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) SKLabelNode *startButton;
@property (strong, nonatomic) SKLabelNode *tutorialButton;
@property (strong, nonatomic) SKLabelNode *helpButton;
@property (strong, nonatomic) SKLabelNode *moreButton;
@property (strong, nonatomic) SKLabelNode *infoButton;
@property (strong, nonatomic) SKLabelNode *gameCenterButton;
@property (strong, nonatomic) UIAlertView *waitingForAppStoreAlertView;

@end

@implementation BIDStartScene

+ (void)initialize {
    gameStartSound = [SKAction playSoundFileNamed:@"gameStart.wav"
                            waitForCompletion:NO];
}

- (instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        _gameCenterButtonEnabled = NO;
        
        self.backgroundColor = [SKColor greenColor];
        
        SKLabelNode *topLabel = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
        topLabel.text = @"TextShooter";
        topLabel.fontColor = [SKColor blackColor];
        topLabel.fontSize = 48;
        topLabel.position = CGPointMake(self.frame.size.width * 0.5,
                                        self.frame.size.height * 0.7);
        [self addChild:topLabel];
        
        SKLabelNode *by = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
        by.text = @"by ";
        by.fontColor = [SKColor blackColor];
        by.fontSize = 24;
        by.position =CGPointMake(self.frame.size.width * 0.5,
                                 self.frame.size.height * 0.55);
        by.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        by.verticalAlignmentMode = SKLabelVerticalAlignmentModeBottom;
        [self addChild:by];
        
        SKSpriteNode *logo = [SKSpriteNode spriteNodeWithImageNamed:@"logotext 256"];
        logo.position = CGPointMake(self.frame.size.width * 0.5,
                                    self.frame.size.height * 0.55);
        logo.xScale = 0.5;
        logo.yScale = 0.5;
        logo.anchorPoint = CGPointMake(0.5, 1);
        [self addChild:logo];
        
        _gameCenterButton = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
        _gameCenterButton.text = @"Game Center Leaderboards";
        _gameCenterButton.fontColor = [SKColor blackColor];
        _gameCenterButton.fontSize = 16;
        _gameCenterButton.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
        _gameCenterButton.position = CGPointMake(self.frame.size.width * 0.5,
                                            self.frame.size.height - 4);
        [self addChild:_gameCenterButton];
        _gameCenterButton.hidden = ![GKLocalPlayer localPlayer].isAuthenticated;

        _startButton = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
        _startButton.text = @"Play Game";
        _startButton.fontColor = [SKColor blackColor];
        _startButton.fontSize = 36;
        _startButton.position = CGPointMake(self.frame.size.width * 0.5,
                                           self.frame.size.height * 0.3);
        [self addChild:_startButton];
        
        _tutorialButton = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
        _tutorialButton.text = @"Tutorial";
        _tutorialButton.fontColor = [SKColor blackColor];
        _tutorialButton.fontSize = 30;
        _tutorialButton.position = CGPointMake(_startButton.position.x,
                                               _startButton.position.y - 60);
        [self addChild:_tutorialButton];
        
        _helpButton = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
        _helpButton.text = @"Help!";
        _helpButton.fontColor = [SKColor blackColor];
        _helpButton.fontSize = 16;
        _helpButton.verticalAlignmentMode = SKLabelVerticalAlignmentModeBaseline;
        _helpButton.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
        _helpButton.position = CGPointMake(self.frame.size.width * 0.98,
                                            self.frame.size.height * 0.02);
        [self addChild:_helpButton];
        
        _infoButton = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
        _infoButton.text = @"Info!";
        _infoButton.fontColor = [SKColor blackColor];
        _infoButton.fontSize = 16;
        _infoButton.verticalAlignmentMode = SKLabelVerticalAlignmentModeBaseline;
        _infoButton.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        _infoButton.position = CGPointMake(self.frame.size.width * 0.02,
                                           self.frame.size.height * 0.02);
        [self addChild:_infoButton];
        
        _moreButton = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
        _moreButton.text = @"More games!";
        _moreButton.fontColor = [SKColor blackColor];
        _moreButton.fontSize = 16;
        _moreButton.verticalAlignmentMode = SKLabelVerticalAlignmentModeBaseline;
        _moreButton.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        _moreButton.position = CGPointMake(self.frame.size.width * 0.5,
                                           self.frame.size.height * 0.02);
        [self addChild:_moreButton];
        
    }
    return self;
}

- (void)setGameCenterButtonEnabled:(BOOL)gameCenterButtonEnabled {
    _gameCenterButton.hidden = !gameCenterButtonEnabled;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if (touchIsInNode(touch, _startButton)) {
        SKTransition *transition = [SKTransition doorwayWithDuration:1.0];
        SKScene *game = [BIDLevelScene sceneWithSize:self.frame.size levelNumber:1 score:0 mode:BIDGameModeNormal];
        [self animateButton:_startButton then:^{
            [self.view presentScene:game transition:transition];
        }];
        
        [self runAction:gameStartSound];
    } else if (touchIsInNode(touch, _tutorialButton)) {
        SKTransition *transition = [SKTransition doorwayWithDuration:1.0];
        SKScene *game = [BIDLevelScene sceneWithSize:self.frame.size levelNumber:1 score:0 mode:BIDGameModeTutorial];
        [self animateButton:_tutorialButton then:^{
            [self.view presentScene:game transition:transition];
        }];
        
        [self runAction:gameStartSound];
    } else if (touchIsInNode(touch, _moreButton)) {
        [self animateButton:_moreButton then:^{
            [self showMultiProductStore];
        }];
    } else if (touchIsInNode(touch, _helpButton)) {
        SKTransition *transition = [SKTransition flipHorizontalWithDuration:0.5];
        SKScene *game = [[BIDHelpScene alloc] initWithSize:self.frame.size];
        [self animateButton:_helpButton then:^{
            [self.view presentScene:game transition:transition];
        }];
    } else if (touchIsInNode(touch, _infoButton)) {
        SKTransition *transition = [SKTransition flipVerticalWithDuration:0.5];
        SKScene *game = [[BIDInfoScene alloc] initWithSize:self.frame.size];
        [self animateButton:_infoButton then:^{
            [self.view presentScene:game transition:transition];
        }];
    } else if (!_gameCenterButton.hidden && touchIsInNode(touch, _gameCenterButton)) {
        [self animateButton:_gameCenterButton then:^{
            [[RBSGameCenterManager shared] showGameCenterWithInitialViewState:GKGameCenterViewControllerStateLeaderboards
                                                        leaderboardIdentifier:nil
                                                            completionHandler:nil];
        }];
    }
}

- (void)showMultiProductStore {
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"OtherRebisoftGames" withExtension:@"json"];
    NSError *error;
    NSData *jsonData = [NSData dataWithContentsOfURL:url];
    if (jsonData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        if (dict) {
            NSArray *specs = dict[@"productSpecs"];
            NSArray *productClusters = [TBTProductCluster productClustersFromSpecs:specs];
            [TBTMultiProductViewController runWithTitle:@"Other Games"
                                        productClusters:productClusters
                                               delegate:nil];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    self.waitingForAppStoreAlertView = nil;
}

@end
