//
//  BIDLevelTwoScene.m
//  TextShooter
//
//  Created by JN on 2014-3-26.
//  Copyright (c) 2014 Apress. All rights reserved.
//

#import "BIDLevelTwoScene.h"
#import "BIDEnemyNode.h"

#define WAIT_INTERVAL

@interface BIDLevelTwoScene ()

@property (assign, nonatomic) BOOL shootingAllowed;
@property (strong, nonatomic) NSDate *levelStartTime;
@property (strong, nonatomic) SKLabelNode *extraInfo1;
@property (strong, nonatomic) SKLabelNode *extraInfo2;
@property (strong, nonatomic) SKLabelNode *extraInfo3;
@property (strong, nonatomic) SKLabelNode *extraInfo4;

@end

@implementation BIDLevelTwoScene

- (instancetype)initWithSize:(CGSize)size levelNumber:(NSUInteger)levelNumber score:(NSUInteger)score mode:(BIDGameMode)gameMode {
    if (!(self = [super initWithSize:size levelNumber:levelNumber score:score mode:(BIDGameMode)gameMode])) return nil;
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
    
    self.extraInfo1.text = @"When any enemy bumps into";
    self.extraInfo2.text = @"another, the next one will";
    self.extraInfo3.text = @"start falling, too.";
    self.extraInfo4.text = @"";
    return self;
}

- (void)spawnEnemies {
    {
        BIDEnemyNode *enemy = [BIDEnemyNode node];
        CGSize size = self.frame.size;
        CGFloat x = (size.width * 0.5) - 25;
        CGFloat y = (size.height * 0.5) + 25;
        enemy.position = CGPointMake(x, y);
        [self.enemies addChild:enemy];
    }
    {
        BIDEnemyNode *enemy = [BIDEnemyNode node];
        CGSize size = self.frame.size;
        CGFloat x = (size.width * 0.5) + 25;
        CGFloat y = (size.height * 0.5) + 25;
        enemy.position = CGPointMake(x, y);
        [self.enemies addChild:enemy];
    }
    {
        BIDEnemyNode *enemy = [BIDEnemyNode node];
        CGSize size = self.frame.size;
        CGFloat x = (size.width * 0.5) - 25;
        CGFloat y = (size.height * 0.5) - 30;
        enemy.position = CGPointMake(x, y);
        [self.enemies addChild:enemy];
    }
    {
        BIDEnemyNode *enemy = [BIDEnemyNode node];
        CGSize size = self.frame.size;
        CGFloat x = (size.width * 0.5) + 25;
        CGFloat y = (size.height * 0.5) - 30;
        enemy.position = CGPointMake(x, y);
        [self.enemies addChild:enemy];
    }
}
@end
