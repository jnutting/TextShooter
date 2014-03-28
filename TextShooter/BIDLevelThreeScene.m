//
//  BIDLevelThreeScene.m
//  TextShooter
//
//  Created by JN on 2014-3-26.
//  Copyright (c) 2014 Apress. All rights reserved.
//

#import "BIDLevelThreeScene.h"
#import "BIDEnemyNode.h"

#define ARC4RANDOM_MAX      0x100000000

@interface BIDLevelThreeScene ()

@property (strong, nonatomic) SKLabelNode *extraInfo1;
@property (strong, nonatomic) SKLabelNode *extraInfo2;
@property (strong, nonatomic) SKLabelNode *extraInfo3;
@property (strong, nonatomic) SKLabelNode *extraInfo4;
@end

@implementation BIDLevelThreeScene

- (instancetype)initWithSize:(CGSize)size levelNumber:(NSUInteger)levelNumber score:(NSUInteger)score mode:(BIDGameMode)gameMode {
    if (!(self = [super initWithSize:size levelNumber:levelNumber score:score mode:(BIDGameMode)gameMode])) return nil;
    
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
    
    self.extraInfo1.text = @"That's all you need to know!";
    self.extraInfo2.text = @"Knock down these last";
    self.extraInfo3.text = @"few enemies to finish";
    self.extraInfo4.text = @"the tutorial.";
    return self;
}
- (void)spawnEnemies {
    {
        BIDEnemyNode *enemy = [BIDEnemyNode node];
        CGSize size = self.frame.size;
        CGFloat x = (size.width * 0.3 * arc4random() / ARC4RANDOM_MAX) +
        (size.width * 0.1);
        CGFloat y = (size.height * 0.25 * arc4random() / ARC4RANDOM_MAX) +
        (size.height * 0.5);
        enemy.position = CGPointMake(x, y);
        [self.enemies addChild:enemy];
    }
    {
        BIDEnemyNode *enemy = [BIDEnemyNode node];
        CGSize size = self.frame.size;
        CGFloat x = size.width - ( (size.width * 0.3 * arc4random() / ARC4RANDOM_MAX) +
        (size.width * 0.1) );
        CGFloat y = (size.height * 0.25 * arc4random() / ARC4RANDOM_MAX) +
        (size.height * 0.5);
        enemy.position = CGPointMake(x, y);
        [self.enemies addChild:enemy];
    }
    {
        BIDEnemyNode *enemy = [BIDEnemyNode node];
        CGSize size = self.frame.size;
        CGFloat x = (size.width * 0.3 * arc4random() / ARC4RANDOM_MAX) +
        (size.width * 0.1);
        CGFloat y = size.height - ( (size.height * 0.25 * arc4random() / ARC4RANDOM_MAX) +
        (size.height * 0.5) );
        enemy.position = CGPointMake(x, y);
        [self.enemies addChild:enemy];
    }
    {
        BIDEnemyNode *enemy = [BIDEnemyNode node];
        CGSize size = self.frame.size;
        CGFloat x = size.width - ( (size.width * 0.3 * arc4random() / ARC4RANDOM_MAX) +
        (size.width * 0.1) );
        CGFloat y = size.height - ( (size.height * 0.25 * arc4random() / ARC4RANDOM_MAX) +
        (size.height * 0.5) );
        enemy.position = CGPointMake(x, y);
        [self.enemies addChild:enemy];
    }
}

- (void)goToNextLevel {
    [self triggerGameOver];
}

@end
