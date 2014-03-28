//
//  SKNode+Extra.h
//  TextShooter
//
//  Created by JN on 2014-1-22.
//  Copyright (c) 2014 Apress. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SKNode (Extra)

- (NSInteger)receiveAttacker:(SKNode *)attacker contact:(SKPhysicsContact *)contact;
- (void)friendlyBumpFrom:(SKNode *)node;

// This doesn't really need to be in SKNode. Could be anywhere, really,
// even just in a function, but here it is for now.
- (void)animateButton:(SKNode *)button then:(void (^)(void))completion;
@end
