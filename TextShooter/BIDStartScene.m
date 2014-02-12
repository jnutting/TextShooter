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

static int rebisoftId = 301618973;

static SKAction *gameStartSound;

@interface BIDStartScene () <SKStoreProductViewControllerDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) SKLabelNode *startButton;
@property (strong, nonatomic) SKLabelNode *helpButton;
@property (strong, nonatomic) SKLabelNode *moreButton;
@property (strong, nonatomic) SKLabelNode *infoButton;
@property (strong, nonatomic) UIAlertView *waitingForAppStoreAlertView;

@end

@implementation BIDStartScene

+ (void)initialize {
    gameStartSound = [SKAction playSoundFileNamed:@"gameStart.wav"
                            waitForCompletion:NO];
}

- (instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
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
        
        _startButton = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
        _startButton.text = @"Touch to start";
        _startButton.fontColor = [SKColor blackColor];
        _startButton.fontSize = 36;
        _startButton.position = CGPointMake(self.frame.size.width * 0.5,
                                           self.frame.size.height * 0.3);
        [self addChild:_startButton];
        
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if (touchIsInNode(touch, _startButton)) {
        SKTransition *transition = [SKTransition doorwayWithDuration:1.0];
        SKScene *game = [[BIDLevelScene alloc] initWithSize:self.frame.size];
        [self.view presentScene:game transition:transition];
        
        [self runAction:gameStartSound];
    } else if (touchIsInNode(touch, _moreButton)) {
        [self showMoreRebisoft:nil];
    } else if (touchIsInNode(touch, _helpButton)) {
        SKTransition *transition = [SKTransition flipHorizontalWithDuration:0.5];
        SKScene *game = [[BIDHelpScene alloc] initWithSize:self.frame.size];
        [self.view presentScene:game transition:transition];
    } else if (touchIsInNode(touch, _infoButton)) {
        SKTransition *transition = [SKTransition flipVerticalWithDuration:0.5];
        SKScene *game = [[BIDInfoScene alloc] initWithSize:self.frame.size];
        [self.view presentScene:game transition:transition];
    }
}

- (IBAction)showMoreRebisoft:(UIControl *)sender {
    [self showStoreForIdentifier:@(rebisoftId)];
}

- (void)showStoreForIdentifier:(NSNumber *)identifier {
    SKStoreProductViewController *vc = [[SKStoreProductViewController alloc] init];
    vc.delegate = self;
    
    NSDictionary *params = @{SKStoreProductParameterITunesItemIdentifier : identifier};
    self.waitingForAppStoreAlertView = [[UIAlertView alloc] initWithTitle:@"Connecting..." message:@"Please wait while we talk to the App Store." delegate:self cancelButtonTitle:@"Forget it!" otherButtonTitles:nil];
    [self.waitingForAppStoreAlertView show];
    
    [vc loadProductWithParameters:params completionBlock:^(BOOL result, NSError *error) {
        if (!self.waitingForAppStoreAlertView) {
            // user aborted
//            NSLog(@"User aborted store session");
            return;
        }
        
        // get rid of the waiting for app store alert
        [self.waitingForAppStoreAlertView dismissWithClickedButtonIndex:0 animated:YES];
        
        if (result) {
//            NSLog(@"we have a result! Time to show the store view controller");
            [[[[[UIApplication sharedApplication] windows] firstObject] rootViewController]
             presentViewController:vc animated:YES completion:nil];
        } else {
//            NSLog(@"error connection to store");
            // The gui isn't going to display. Give the user some feedback.
            [[[UIAlertView alloc] initWithTitle:@"No luck!" message:[error localizedDescription] delegate:self cancelButtonTitle:@"Dang!" otherButtonTitles:nil] show];
        }
    }];
}

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    self.waitingForAppStoreAlertView = nil;
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    self.waitingForAppStoreAlertView = nil;
}

@end
