//
//  BIDInfoScene.m
//  TextShooter
//
//  Created by JN on 2014-2-12.
//  Copyright (c) 2014 Apress. All rights reserved.
//

#import "BIDInfoScene.h"
#import "BIDStartScene.h"
#import "BIDGeometry.h"

@interface BIDInfoScene ()

@property (strong, nonatomic) SKSpriteNode *bookLogo;

@end

@implementation BIDInfoScene

- (instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor darkGrayColor];
        
        /*
        SKLabelNode *topLabel = [SKLabelNode labelNodeWithFontNamed:@"Courier-Oblique"];
        topLabel.text = @"Help!";
        topLabel.fontColor = [SKColor blackColor];
        topLabel.fontSize = 48;
        topLabel.position = CGPointMake(self.frame.size.width * 0.5,
                                        self.frame.size.height * 0.9);
        [self addChild:topLabel];
        
        SKLabelNode *text1 = [SKLabelNode labelNodeWithFontNamed:@"Courier-Oblique"];
        text1.text = @"- Tap upper screen to shoot";
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
         */
        
        _bookLogo = [SKSpriteNode spriteNodeWithImageNamed:@"bid7_small"];
        _bookLogo.position = CGPointMake(self.frame.size.width * 0.5,
                                    self.frame.size.height - 8);
        _bookLogo.xScale = 0.5;
        _bookLogo.yScale = 0.5;
        _bookLogo.anchorPoint = CGPointMake(0.5, 1);
        [self addChild:_bookLogo];
        
        CGFloat y = self.frame.size.height - 375 - 16;

        SKLabelNode *text1 = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
        text1.text = @"Want to learn how to make games like this?";
        text1.fontColor = [SKColor whiteColor];
        text1.fontSize = 12;
        text1.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
        text1.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        text1.position = CGPointMake(8, y);
        [self addChild:text1];
        
        y -= 15;
        
        SKLabelNode *text2 = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
        text2.text = @"Buy \"Beginning iOS 7 Development\" for";
        text2.fontColor = [SKColor whiteColor];
        text2.fontSize = 12;
        text2.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
        text2.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        text2.position = CGPointMake(8, y);
        [self addChild:text2];
        
        y -= 15;
        
        SKLabelNode *text3 = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
        text3.text = @"complete description and source code.";
        text3.fontColor = [SKColor whiteColor];
        text3.fontSize = 12;
        text3.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
        text3.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        text3.position = CGPointMake(8, y);
        [self addChild:text3];
        
        
        SKLabelNode *text4 = [SKLabelNode labelNodeWithFontNamed:@"Courier-Oblique"];
        text4.text = @"Back to menu!";
        text4.fontColor = [SKColor whiteColor];
        text4.fontSize = 17;
        text4.verticalAlignmentMode = SKLabelVerticalAlignmentModeBottom;
        text4.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        text4.position = CGPointMake(self.frame.size.width * 0.5, 8);
        [self addChild:text4];

    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if (touchIsInNode(touch, _bookLogo)) {
        NSURL *url = [NSURL URLWithString:@"http://www.amazon.com/Beginning-iOS-Development-Exploring-SDK/dp/143026022X&tag=rebisoft-20"];
        [[UIApplication sharedApplication] openURL:url];
    } else {
        SKTransition *transition = [SKTransition revealWithDirection:SKTransitionDirectionUp duration:0.5];
        SKScene *game = [[BIDStartScene alloc] initWithSize:self.frame.size];
        [self.view presentScene:game transition:transition];
    }
}


@end
