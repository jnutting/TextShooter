//
//  BIDMyScene.m
//  TextShooter
//
//  Created by JN on 2013-12-6.
//  Copyright (c) 2013 Apress. All rights reserved.
//

#import "BIDLevelScene.h"
#import "BIDPlayerNode.h"
#import "BIDEnemyNode.h"
#import "BIDBulletNode.h"
#import "SKNode+Extra.h"
#import "BIDGameOverScene.h"
#import "BIDStartScene.h"
#import "BIDGeometry.h"
#import "BIDLevelSceneFactory.h"

#define ARC4RANDOM_MAX      0x100000000

#define BULLET_FIRE_POINT -1
#define PUSH_ENEMY_OFF_TOP_POINTS 100
#define PUSH_ENEMY_OFF_SIDE_POINTS 20

#define PLAYER_AREA_HEIGHT 44

@class BIDLevelOneScene;
@class BIDLevelTwoScene;
@class BIDLevelThreeScene;

@interface BIDLevelScene () <SKPhysicsContactDelegate>

@property (strong, nonatomic) BIDPlayerNode *playerNode;
@property (strong, nonatomic) SKNode *playerBullets;
@property (assign, nonatomic) BOOL isPaused;
@property (strong, nonatomic) SKLabelNode *toMenu;
@property (strong, nonatomic) SKAction *pulsate;

@end

static SKAction *gameOverSound;
static SKAction *levelCompleteSound;

@implementation BIDLevelScene

+ (void)initialize {
    gameOverSound = [SKAction playSoundFileNamed:@"gameOver.wav"
                               waitForCompletion:NO];
    levelCompleteSound = [SKAction playSoundFileNamed:@"levelComplete.wav"
                                    waitForCompletion:NO];
}

+ (instancetype)sceneWithSize:(CGSize)size levelNumber:(NSUInteger)levelNumber score:(NSUInteger)score mode:(BIDGameMode)gameMode
{
    Class klass = [BIDLevelSceneFactory sceneClassForLevelNumber:levelNumber mode:gameMode];
    return [[klass alloc] initWithSize:size levelNumber:levelNumber score:(NSUInteger)score mode:gameMode];
}

- (instancetype)initWithSize:(CGSize)size
{
    return [self initWithSize:size levelNumber:1 score:0 mode:BIDGameModeNormal];
}

- (instancetype)initWithSize:(CGSize)size levelNumber:(NSUInteger)levelNumber score:(NSUInteger)score mode:(BIDGameMode)gameMode {
    if (self = [super initWithSize:size]) {
        
        _mode = gameMode;
        _pulsate = [SKAction sequence:@[[SKAction scaleXTo:1.2 y:1.2 duration:0.02],
                                        [SKAction scaleXTo:1.0 y:1.0 duration:0.06]]];
        
        _score = score;
        _levelNumber = levelNumber;
        _playerLives = 5;
        _isPaused = NO;

        SKShapeNode *lowerBackdrop = [SKShapeNode node];
        CGRect lowerBackdropRect = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), PLAYER_AREA_HEIGHT);
        UIBezierPath *lowerBackdropPath = [UIBezierPath bezierPathWithRect:lowerBackdropRect];
        lowerBackdrop.path = lowerBackdropPath.CGPath;
        lowerBackdrop.fillColor = [UIColor colorWithWhite:0.9 alpha:1.0];
        lowerBackdrop.strokeColor = [UIColor blackColor];
        lowerBackdrop.lineWidth = 0;
        [self addChild:lowerBackdrop];
        
        _playerNode = [BIDPlayerNode node];
        _playerNode.position = CGPointMake(CGRectGetMidX(self.frame),
                                           CGRectGetMinX(self.frame) + 30);
        
        [self addChild:_playerNode];
        _enemies = [SKNode node];
        [self addChild:_enemies];
        [self spawnEnemies];
        
        _playerBullets = [SKNode node];
        [self addChild:_playerBullets];

        
        self.backgroundColor = [SKColor whiteColor];
        
        SKShapeNode *backdrop = [SKShapeNode node];
        CGRect backdropRect = CGRectMake(CGRectGetMinX(self.frame), CGRectGetHeight(self.frame) - 40, CGRectGetWidth(self.frame), 40);
        UIBezierPath *backdropPath = [UIBezierPath bezierPathWithRect:backdropRect];
        backdrop.path = backdropPath.CGPath;
        backdrop.fillColor = [UIColor whiteColor];
        backdrop.strokeColor = [UIColor blackColor];
        backdrop.lineWidth = 0.5;
        [self addChild:backdrop];
        
        SKLabelNode *lives = [SKLabelNode labelNodeWithFontNamed:@"Courier-Oblique"];
        lives.fontSize = 16;
        lives.fontColor = [SKColor blackColor];
        lives.name = @"LivesLabel";
        lives.text = [NSString stringWithFormat:@"%lu Lives",
                      (unsigned long)_playerLives];
        lives.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        lives.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
        lives.position = CGPointMake(self.frame.size.width - 5,
                                     self.frame.size.height - 20);
        [self addChild:lives];
        
        SKLabelNode *score = [SKLabelNode labelNodeWithFontNamed:@"Courier-Bold"];
        score.fontSize = 24;
        score.fontColor = [SKColor blackColor];
        score.name = @"ScoreLabel";
        score.text = [NSString stringWithFormat:@"%d", _score];
        score.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        score.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        score.position = CGPointMake(CGRectGetMidX(self.frame),
                                     self.frame.size.height - 20);
        [self addChild:score];
        
        SKLabelNode *level = [SKLabelNode labelNodeWithFontNamed:@"Courier-Oblique"];
        level.fontSize = 16;
        level.fontColor = [SKColor blackColor];
        level.name = @"LevelLabel";
        level.text = [NSString stringWithFormat:@"Level %lu",
                      (unsigned long)_levelNumber];
        level.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        level.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        level.position = CGPointMake(5, self.frame.size.height - 20);
        [self addChild:level];

        
        
        
        
        SKNode *pausedNode = [SKNode node];
        pausedNode.name = @"PausedNode";
        
        SKShapeNode *pausedBackdrop = [SKShapeNode node];
        CGRect pausedBackdropRect = CGRectInset(self.frame, 20, 80);
        UIBezierPath *pausedBackdropPath = [UIBezierPath bezierPathWithRect:pausedBackdropRect];
        pausedBackdrop.path = pausedBackdropPath.CGPath;
        pausedBackdrop.fillColor = [UIColor colorWithWhite:0.5 alpha:0.8];
        pausedBackdrop.strokeColor = [UIColor blackColor];
        [pausedNode addChild:pausedBackdrop];
        
        SKLabelNode *paused = [SKLabelNode labelNodeWithFontNamed:@"Courier-Oblique"];
        paused.fontSize = 48;
        paused.fontColor = [SKColor redColor];
        paused.text = @"Paused";
        paused.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        paused.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        paused.position = CGPointMake(CGRectGetMidX(self.frame),
                                      CGRectGetMidY(self.frame) + 140);
        [pausedNode addChild:paused];

        self.toMenu = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
        _toMenu.name = @"quitButton";
        _toMenu.fontSize = 24;
        _toMenu.fontColor = [SKColor blackColor];
        _toMenu.text = @"Quit to Menu";
        _toMenu.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        _toMenu.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        _toMenu.position = CGPointMake(CGRectGetMidX(self.frame),
                                      CGRectGetMidY(self.frame) - 145);
        [pausedNode addChild:_toMenu];

        SKLabelNode *resume = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
        resume.fontSize = 36;
        resume.fontColor = [SKColor blackColor];
        resume.text = @"Resume";
        resume.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        resume.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        resume.position = CGPointMake(CGRectGetMidX(self.frame),
                                      CGRectGetMidY(self.frame));
        [pausedNode addChild:resume];

        pausedNode.hidden = YES;
        [self addChild:pausedNode];

        self.physicsWorld.gravity = CGVectorMake(0, -1);
        self.physicsWorld.contactDelegate = self;
    }
    return self;
}

- (void)setPlayerLives:(NSUInteger)playerLives {
    _playerLives = playerLives;
    SKLabelNode *lives = (id)[self childNodeWithName:@"LivesLabel"];
    lives.text = [NSString stringWithFormat:@"%lu Lives",
                  (unsigned long)_playerLives];
}

- (void)setScore:(NSInteger)score {
    SKLabelNode *scoreLabel = (id)[self childNodeWithName:@"ScoreLabel"];
    if (score > _score) {
        [self pulsate:scoreLabel];
    }
    _score = score;
    scoreLabel.text = [NSString stringWithFormat:@"%d", _score];
}

- (void)pulsate:(SKNode *)node {
    [node removeActionForKey:@"pulsate"];
    [node runAction:self.pulsate withKey:@"pulsate"];
}

- (void)movePlayerToward:(CGPoint)location {
    CGPoint target = CGPointMake(location.x,
                                 self.playerNode.position.y);
    [self.playerNode moveToward:target];
}

- (void)fireBulletToward:(CGPoint)location {
    BIDBulletNode *bullet = [BIDBulletNode
                             bulletFrom:self.playerNode.position
                             toward:location];
    if (bullet) {
        [self.playerBullets addChild:bullet];
        self.score += BULLET_FIRE_POINT;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        if (self.isPaused) {
            if (touchIsInNode(touch, _toMenu)) {
                // quit to menu
                SKTransition *transition = [SKTransition doorsCloseHorizontalWithDuration:0.5];
                SKScene *gameOver = [[BIDStartScene alloc] initWithSize:self.frame.size];
                [self.view presentScene:gameOver transition:transition];
            } else {
                // tap anywhere to unpause
                [self togglePause];
            }
        } else {
            if (location.y > CGRectGetHeight(self.frame) - 40) {
                // tap in pause area
                [self togglePause];
            } else if (location.y < PLAYER_AREA_HEIGHT ) {
                [self movePlayerToward:location];
            } else {
                [self fireBulletToward:location];
            }

        }
        
    }
}

- (void)spawnEnemies {
    NSUInteger count = log(self.levelNumber) + self.levelNumber;
    for (NSUInteger i = 0; i < count; i++) {
        BIDEnemyNode *enemy = [BIDEnemyNode node];
        CGSize size = self.frame.size;
        CGFloat x = (size.width * 0.8 * arc4random() / ARC4RANDOM_MAX) +
        (size.width * 0.1);
        CGFloat y = (size.height * 0.5 * arc4random() / ARC4RANDOM_MAX) +
        (size.height * 0.5) - 40;
        enemy.position = CGPointMake(x, y);
        [self.enemies addChild:enemy];
    }
}

- (void)update:(CFTimeInterval)currentTime {
    if (self.finished || self.isPaused) return;
    
    [self updateBullets];
    [self updateEnemies];
    if (![self checkForGameOver]) {
        [self checkForNextLevel];
    }
}

- (void)updateBullets {
    NSMutableArray *bulletsToRemove = [NSMutableArray array];
    for (BIDBulletNode *bullet in self.playerBullets.children) {
        // Remove any bullets that have moved off-screen
        if (!CGRectContainsPoint(self.frame, bullet.position)) {
            // mark bullet for removal
            [bulletsToRemove addObject:bullet];
            continue;
        }
        // Apply thrust to remaining bullets
        [bullet applyRecurringForce];
    }
    [self.playerBullets removeChildrenInArray:bulletsToRemove];
}

- (void)updateEnemies {
    NSMutableArray *enemiesToRemove = [NSMutableArray array];
    for (SKNode *node in self.enemies.children) {
        // Remove any enemies that have moved off-screen
        if (!CGRectContainsPoint(CGRectInset(self.frame, -40, -40), node.position)) {
            // mark enemy for removal
            [enemiesToRemove addObject:node];
            if (node.position.y > CGRectGetMaxY(self.frame)) {
                NSLog(@"off top");
                self.score += PUSH_ENEMY_OFF_TOP_POINTS;
            } else if (node.position.x < CGRectGetMinX(self.frame) || node.position.x >CGRectGetMaxX(self.frame)) {
                NSLog(@"off side");
                self.score += PUSH_ENEMY_OFF_SIDE_POINTS;
            } else {
                NSLog(@"off bottom");
            }
            continue;
        }
    }
    if ([enemiesToRemove count] > 0) {
        [self.enemies removeChildrenInArray:enemiesToRemove];
    }
}

- (BOOL)checkForGameOver {
    if (self.playerLives == 0) {
        [self triggerGameOver];
        return YES;
    }
    return NO;
}

- (void)triggerGameOver
{
    self.finished = YES;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"EnemyExplosion"
                                                     ofType:@"sks"];
    SKEmitterNode *explosion = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    explosion.numParticlesToEmit = 200;
    explosion.position = _playerNode.position;
    [self addChild:explosion];
    [_playerNode removeFromParent];
    
    SKTransition *transition = [SKTransition doorsOpenVerticalWithDuration:1.0];
    BIDGameOverScene *gameOver = [[BIDGameOverScene alloc] initWithSize:self.frame.size deathLevel:self.levelNumber mode:self.mode];
    [self.view presentScene:gameOver transition:transition];
    
    [self runAction:gameOverSound];
}

- (void)checkForNextLevel
{
    if ([self.enemies.children count] == 0) {
        [self goToNextLevel];
        [self runAction:levelCompleteSound];
    }
}

- (void)goToNextLevel
{
    self.finished = YES;
    
    SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
    label.text = @"Level Complete!";
    label.fontColor = [SKColor blueColor];
    label.fontSize = 32;
    label.position = CGPointMake(self.frame.size.width * 0.5,
                                 self.frame.size.height * 0.5);
    [self addChild:label];
    
    BIDLevelScene *nextLevel = [BIDLevelScene
                                sceneWithSize:self.frame.size
                                levelNumber:self.levelNumber + 1
                                score:self.score
                                mode:self.mode];
    nextLevel.playerLives = self.playerLives;
    [self.view presentScene:nextLevel
                 transition:[SKTransition flipHorizontalWithDuration:1.0]];
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    if (contact.bodyA.categoryBitMask == contact.bodyB.categoryBitMask) {
        // Both bodies are in the same category
        SKNode *nodeA = contact.bodyA.node;
        SKNode *nodeB = contact.bodyB.node;
        
        // What do we do with these nodes?
        [nodeA friendlyBumpFrom:nodeB];
        [nodeB friendlyBumpFrom:nodeA];
    } else {
        SKNode *attacker = nil;
        SKNode *attackee = nil;
        
        if (contact.bodyA.categoryBitMask > contact.bodyB.categoryBitMask) {
            // Body A is attacking Body B
            attacker = contact.bodyA.node;
            attackee = contact.bodyB.node;
        } else {
            // Body B is attacking Body A
            attacker = contact.bodyB.node;
            attackee = contact.bodyA.node;
        }
        if ([attackee isKindOfClass:[BIDPlayerNode class]]) {
            self.playerLives--;
        }
        // What do we do with the attacker and the attackee?
        if (attacker) {
            self.score += [attackee receiveAttacker:attacker contact:contact];
            [self.playerBullets removeChildrenInArray:@[attacker]];
            [self.enemies removeChildrenInArray:@[attacker]];
        }
    }
}

- (void)togglePause {
    self.isPaused = !self.isPaused;
}

- (void)setIsPaused:(BOOL)isPaused {
    _isPaused = isPaused;
    SKLabelNode *paused = (id)[self childNodeWithName:@"PausedNode"];
    if (_isPaused) {
        self.physicsWorld.speed = 0;
        self.speed = 0;
        paused.hidden = NO;
    } else {
        self.physicsWorld.speed = 1;
        self.speed = 1;
        paused.hidden = YES;
    }
}

@end
