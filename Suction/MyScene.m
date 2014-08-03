//
//  MyScene.m
//  Suction
//
//  Created by Sam Green on 7/31/14.
//  Copyright (c) 2014 Sam Green. All rights reserved.
//

#import "MyScene.h"
#import "SuctionNode.h"

@interface MyScene ()

@property (nonatomic, strong) SuctionNode *suctionNode;

@end

@implementation MyScene

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        [self initUI];
        
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        self.physicsBody.collisionBitMask = 1;
        self.physicsBody.categoryBitMask = 1;
        self.physicsBody.dynamic = NO;
        
        self.suctionNode = [SuctionNode node];
        self.suctionNode.position = CGPointMake(CGRectGetMidX(self.frame),
                                                CGRectGetMidY(self.frame));
        [self addChild:self.suctionNode];
        [self.suctionNode toggleRedSuction];
        
        [self initSuctionJoint];
    }
    return self;
}

- (void)initUI {
    SKLabelNode *redSuctionLabelNode = [MyScene newLabelNode:@"Suction" withFontColor:[SKColor redColor]];
    redSuctionLabelNode.position = CGPointMake(80, 192);
    [self addChild:redSuctionLabelNode];
    
    SKLabelNode *redForceLabelNode = [MyScene newLabelNode:@"Apply Force" withFontColor:[SKColor redColor]];
    redForceLabelNode.position = CGPointMake(80, 576);
    [self addChild:redForceLabelNode];
    
    SKLabelNode *blueSuctionLabelNode = [MyScene newLabelNode:@"Suction" withFontColor:[SKColor blueColor]];
    blueSuctionLabelNode.position = CGPointMake(944, 192);
    [self addChild:blueSuctionLabelNode];
    
    SKLabelNode *blueForceLabelNode = [MyScene newLabelNode:@"Apply Force" withFontColor:[SKColor blueColor]];
    blueForceLabelNode.position = CGPointMake(944, 576);
    [self addChild:blueForceLabelNode];
}

- (void)initSuctionJoint {
    CGPoint redCenter = CGPointMake(self.suctionNode.redNode.position.x + 64.f, self.suctionNode.redNode.position.y);
    CGPoint blueCenter = CGPointMake(self.suctionNode.blueNode.position.x - 64.f, self.suctionNode.blueNode.position.y);
    CGPoint redPos = [self convertPoint:redCenter fromNode:self.suctionNode.redNode];
    CGPoint bluePos = [self convertPoint:blueCenter fromNode:self.suctionNode.blueNode];
    SKPhysicsJointLimit *limitJoint = [SKPhysicsJointLimit jointWithBodyA:self.suctionNode.redNode.physicsBody
                                                                    bodyB:self.suctionNode.blueNode.physicsBody
                                                                  anchorA:redPos
                                                                  anchorB:bluePos];
    [self.physicsWorld addJoint:limitJoint];
}

+ (SKLabelNode *)newLabelNode:(NSString *)text withFontColor:(SKColor *)fontColor {
    SKLabelNode *labelNode = [SKLabelNode labelNodeWithFontNamed:@"Helvetica-Neue"];
    labelNode.fontSize = 20.f;
    labelNode.fontColor = fontColor;
    labelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    labelNode.text = text;
    return labelNode;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    static const CGFloat kRedMaxTouchX = 120.f;
    static const CGFloat kBlueMinTouchX = 904.f;
    static const CGFloat kMidTouchY = 384.f;
    
    if (location.x < kRedMaxTouchX) {
        if (location.y < kMidTouchY) {
            [self.suctionNode toggleRedSuction];
        } else {
            [self.suctionNode accelerateRedNode];
        }
    } else if (location.x > kBlueMinTouchX) {
        if (location.y < kMidTouchY) {
            [self.suctionNode toggleBlueSuction];
        } else {
            [self.suctionNode accelerateBlueNode];
        }
    } else {
        NSLog(@"Touch %@", NSStringFromCGPoint(location));
    }
}

- (void)update:(CFTimeInterval)currentTime {
    
}

@end
