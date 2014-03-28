//
//  SKNode+Extra.m
//  TextShooter
//
//  Created by JN on 2014-1-22.
//  Copyright (c) 2014 Apress. All rights reserved.
//

#import "SKNode+Extra.h"

@implementation SKNode (Extra)

- (NSInteger)receiveAttacker:(SKNode *)attacker contact:(SKPhysicsContact *)contact;
{
    // default implementation does nothing
    return 0;
}

- (void)friendlyBumpFrom:(SKNode *)node
{
    // default implementation does nothing
}

@end
