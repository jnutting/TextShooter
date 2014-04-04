//
//  BIDLevelSceneFactory.h
//  TextShooter
//
//  Created by JN on 2014-3-26.
//  Copyright (c) 2014 Apress. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BIDLevelScene.h"

@interface BIDLevelSceneFactory : NSObject

+ (Class)sceneClassForLevelNumber:(NSUInteger)number mode:(BIDGameMode)mode;

@end
