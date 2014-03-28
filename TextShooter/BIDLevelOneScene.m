//
//  BIDLevelOneScene.m
//  TextShooter
//
//  Created by JN on 2014-3-26.
//  Copyright (c) 2014 Apress. All rights reserved.
//

#import "BIDLevelOneScene.h"
#import "BIDEnemyNode.h"

#define MINIMUM_MOVES 3
#define MINIMUM_MOVE_INTERVAL 5

@interface BIDLevelOneScene ()

@property (assign, nonatomic) BOOL shootingAllowed;
@property (strong, nonatomic) NSDate *levelStartTime;
@property (assign, nonatomic) NSUInteger movementCounter;
@property (strong, nonatomic) SKLabelNode *extraInfo1;
@property (strong, nonatomic) SKLabelNode *extraInfo2;
@property (strong, nonatomic) SKLabelNode *extraInfo3;
@property (strong, nonatomic) SKLabelNode *extraInfo4;
@end

@implementation BIDLevelOneScene

- (instancetype)initWithSize:(CGSize)size levelNumber:(NSUInteger)levelNumber score:(NSUInteger)score mode:(BIDGameMode)gameMode {
    if (!(self = [super initWithSize:size levelNumber:levelNumber score:score mode:gameMode])) return nil;
    _levelStartTime = [NSDate date];
    
    CGFloat y = self.frame.size.height - 55;
    for (NSString *labelName in @[@"extraInfo1", @"extraInfo2", @"extraInfo3", @"extraInfo4"]) {
        SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
        label.fontSize = 16;
        label.fontColor = [SKColor blackColor];
        label.name = labelName;
        label.text = labelName;
        label.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        label.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        label.position = CGPointMake(5, y);
        [self addChild:label];
        [self setValue:label forKey:labelName];
        y -= 18;
    }
    
    self.extraInfo1.text = @"Tap in the lower part";
    self.extraInfo2.text = @"of the screen a few";
    self.extraInfo3.text = @"times to move your ship";
    self.extraInfo4.text = @"back and forth.";
    return self;
}

- (void)spawnEnemies {
    BIDEnemyNode *enemy = [BIDEnemyNode node];
    CGSize size = self.frame.size;
    CGFloat x = (size.width * 0.5);
    CGFloat y = (size.height * 0.5);
    enemy.position = CGPointMake(x, y);
    [self.enemies addChild:enemy];
    // The one enemy we make is invisible, temporarily
    self.enemies.hidden = YES;
}

// no shooting during initial period
- (void)fireBulletToward:(CGPoint)location {
    if (self.shootingAllowed) {
        [super fireBulletToward:location];
    }
}

// require the player to move around a bit, over some
// period of time, before going on
- (void)movePlayerToward:(CGPoint)location {
    [super movePlayerToward:location];
    self.movementCounter++;
    NSDate *now = [NSDate date];
    if (self.movementCounter >= MINIMUM_MOVES &&
        [now timeIntervalSinceDate:self.levelStartTime] > MINIMUM_MOVE_INTERVAL) {
        [self tellPlayerAboutEnemies];
    }
}

- (void)tellPlayerAboutEnemies {
    self.extraInfo1.text = @"Great job! Now you'll";
    self.extraInfo2.text = @"see an enemy appear.";
    self.extraInfo3.text = @"Tap on it to shoot, and";
    self.extraInfo4.text = @"avoid it while it's falling!";
    [self runAction:[SKAction sequence:@[[SKAction waitForDuration:3],
                                         [SKAction runBlock:^{
        self.enemies.hidden = NO;
        self.shootingAllowed = YES;
    }]]]];
}

@end
