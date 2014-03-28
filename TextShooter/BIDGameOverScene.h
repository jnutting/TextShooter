//
//  BIDGameOverScene.h
//  TextShooter
//
//  Created by JN on 2014-1-23.
//  Copyright (c) 2014 Apress. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "BIDLevelScene.h"

@interface BIDGameOverScene : SKScene

- (instancetype)initWithSize:(CGSize)size deathLevel:(NSUInteger)deathLevel mode:(BIDGameMode)mode;

@end
