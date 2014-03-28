//
//  BIDMyScene.h
//  TextShooter
//

//  Copyright (c) 2013 Apress. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(NSUInteger, BIDGameMode) {
    BIDGameModeTutorial,
    BIDGameModeNormal,
};

@interface BIDLevelScene : SKScene

@property (assign, nonatomic) NSUInteger levelNumber;
@property (assign, nonatomic) NSInteger score;
@property (assign, nonatomic) NSUInteger playerLives;
@property (assign, nonatomic) BOOL finished;
@property (assign, nonatomic) BIDGameMode mode;

+ (instancetype)sceneWithSize:(CGSize)size levelNumber:(NSUInteger)levelNumber score:(NSUInteger)score mode:(BIDGameMode)gameMode;
- (instancetype)initWithSize:(CGSize)size levelNumber:(NSUInteger)levelNumber score:(NSUInteger)score mode:(BIDGameMode)gameMode;

// The following properties and methods are only for use
// by subclasses.

@property (strong, nonatomic) SKNode *enemies;

- (void)fireBulletToward:(CGPoint)location;
- (void)movePlayerToward:(CGPoint)location;

- (void)goToNextLevel;
- (void)triggerGameOver;

@end
