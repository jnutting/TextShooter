//
//  BIDLevelSceneFactory.m
//  TextShooter
//
//  Created by JN on 2014-3-26.
//  Copyright (c) 2014 Apress. All rights reserved.
//

#import "BIDLevelSceneFactory.h"

#import "BIDLevelScene.h"
#import "BIDLevelOneScene.h"
#import "BIDLevelTwoScene.h"
#import "BIDLevelThreeScene.h"

@implementation BIDLevelSceneFactory

+ (Class)sceneClassForLevelNumber:(int)number mode:(BIDGameMode)mode {
    Class klass = nil;
    switch (mode) {
        case BIDGameModeNormal:
            klass = [BIDLevelScene class];
            break;
        case BIDGameModeTutorial:
            // special cases for a few levels
            switch (number) {
                case 1:
                    klass = [BIDLevelOneScene class];
                    break;
                case 2:
                    klass = [BIDLevelTwoScene class];
                    break;
                case 3:
                    klass = [BIDLevelThreeScene class];
                    break;
                default:
                    klass = [BIDLevelScene class];
                    break;
            }
            break;
    }
    return klass;
}

@end
