//
//  BIDBulletNode.m
//  TextShooter
//
//  Created by JN on 2014-1-17.
//  Copyright (c) 2014 Apress. All rights reserved.
//

#import "BIDBulletNode.h"
#import "BIDPhysicsCategories.h"
#import "BIDGeometry.h"

@interface BIDBulletNode ()

@property (assign, nonatomic) CGVector thrust;

@end

static SKAction *shootSound;

@implementation BIDBulletNode

+ (void)initialize {
    shootSound = [SKAction playSoundFileNamed:@"shoot.wav"
                            waitForCompletion:NO];
}

- (instancetype)init
{
    if (self = [super init]) {
        SKLabelNode *dot = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
        dot.fontColor = [SKColor blackColor];
        dot.fontSize = 40;
        dot.text = @".";
        [self addChild:dot];
        
        SKPhysicsBody *body = [SKPhysicsBody bodyWithCircleOfRadius:1];
        body.dynamic = YES;
        body.categoryBitMask = PlayerMissileCategory;
        body.contactTestBitMask = EnemyCategory;
        body.collisionBitMask = EnemyCategory;
        body.mass = 0.01;
        
        self.physicsBody = body;
        self.name = [NSString stringWithFormat:@"Bullet %p", self];
    }
    return self;
}

+ (instancetype)bulletFrom:(CGPoint)start toward:(CGPoint)destination
{
    BIDBulletNode *bullet = [[self alloc] init];
    
    bullet.position = start;
    
    CGVector movement = BIDVectorBetweenPoints(start, destination);
    CGFloat magnitude = BIDVectorLength(movement);
    if (magnitude == 0.0f) return nil;
    
    CGVector scaledMovement = BIDVectorMultiply(movement, 1 / magnitude);
    
    CGFloat thrustMagnitude = 100.0;
    bullet.thrust = BIDVectorMultiply(scaledMovement, thrustMagnitude);
    
    [bullet runAction:shootSound];

    return bullet;
}

- (void)applyRecurringForce {
    [self.physicsBody applyForce:self.thrust];
}

@end
