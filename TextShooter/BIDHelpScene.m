//
//  BIDHelpScene.m
//  TextShooter
//
//  Created by JN on 2014-2-4.
//  Copyright (c) 2014 Apress. All rights reserved.
//

#import "BIDHelpScene.h"
#import "BIDStartScene.h"

@implementation BIDHelpScene
- (instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor yellowColor];
        
        SKLabelNode *topLabel = [SKLabelNode labelNodeWithFontNamed:@"Courier-Oblique"];
        topLabel.text = @"Help!";
        topLabel.fontColor = [SKColor blackColor];
        topLabel.fontSize = 48;
        topLabel.position = CGPointMake(self.frame.size.width * 0.5,
                                        self.frame.size.height * 0.9);
        [self addChild:topLabel];
        
        SKLabelNode *text1 = [SKLabelNode labelNodeWithFontNamed:@"Courier-Oblique"];
        text1.text = @"- Tap enemies to shoot";
        text1.fontColor = [SKColor blackColor];
        text1.fontSize = 17;
        text1.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        text1.position = CGPointMake(self.frame.size.width * 0.05,
                                        self.frame.size.height * 0.6);
        [self addChild:text1];

        SKLabelNode *text2 = [SKLabelNode labelNodeWithFontNamed:@"Courier-Oblique"];
        text2.text = @"- Tap lower screen to move";
        text2.fontColor = [SKColor blackColor];
        text2.fontSize = 17;
        text2.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        text2.position = CGPointMake(self.frame.size.width * 0.05,
                                     self.frame.size.height * 0.5);
        [self addChild:text2];
        
        SKLabelNode *text3 = [SKLabelNode labelNodeWithFontNamed:@"Courier-Oblique"];
        text3.text = @"- Avoid falling enemies";
        text3.fontColor = [SKColor blackColor];
        text3.fontSize = 17;
        text3.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        text3.position = CGPointMake(self.frame.size.width * 0.05,
                                     self.frame.size.height * 0.4);
        [self addChild:text3];
        
        SKLabelNode *text4 = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
        text4.text = @"Tap anywhere to continue";
        text4.fontColor = [SKColor blackColor];
        text4.fontSize = 17;
        text4.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        text4.position = CGPointMake(self.frame.size.width * 0.5,
                                     self.frame.size.height * 0.1);
        [self addChild:text4];
        
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    SKTransition *transition = [SKTransition flipVerticalWithDuration:0.5];
    SKScene *game = [[BIDStartScene alloc] initWithSize:self.frame.size];
    [self.view presentScene:game transition:transition];
}

@end
