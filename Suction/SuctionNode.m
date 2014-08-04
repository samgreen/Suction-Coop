//
//  SuctionNode.m
//  Suction
//
//  Created by Sam Green on 8/1/14.
//  Copyright (c) 2014 Sam Green. All rights reserved.
//

#import "SuctionNode.h"
#import "HealthNode.h"
#import "SKEffectNode+CoreImageHelpers.h"

@interface SuctionNode ()

@property (nonatomic, strong) SKEffectNode *blueEffectNode;
@property (nonatomic, strong) SKEffectNode *orangeEffectNode;

@property (nonatomic, strong) SKShapeNode *blueNode;
@property (nonatomic, strong) SKShapeNode *orangeNode;

@property (nonatomic, strong) HealthNode *blueHealthNode;
@property (nonatomic, strong) HealthNode *orangeHealthNode;

@property (nonatomic, strong) SKPhysicsJointPin *bluePinJoint;
@property (nonatomic, strong) SKPhysicsJointPin *orangePinJoint;

@property (nonatomic) NSInteger orangeHealth;
@property (nonatomic) NSInteger blueHealth;

@end

@implementation SuctionNode

- (instancetype)init {
    self = [super init];
    if (self) {
        self.blueHealth = 3;
        self.orangeHealth = 3;
        
//#if DEBUG
//        self.blueHealth = 100;
//        self.orangeHealth = 100;
//#endif
        
#if !(TARGET_IPHONE_SIMULATOR)
        self.blueEffectNode = [SKEffectNode nodeWithFilterNamed:@"CIGaussianBlur"
                                                 andInputRadius:5];
#else
        self.blueEffectNode = [SKEffectNode node];
#endif
        [self addChild:self.blueEffectNode];

#if !(TARGET_IPHONE_SIMULATOR)
        self.orangeEffectNode = [SKEffectNode nodeWithFilterNamed:@"CIGaussianBlur"
                                                   andInputRadius:5];
#else
        self.orangeEffectNode = [SKEffectNode node];
#endif
        [self addChild:self.orangeEffectNode];

        
        self.blueNode = [SuctionNode newSuctionNode:[SKColor blueColor] atPosition:CGPointMake(64.f, 0)];
        self.blueNode.physicsBody.categoryBitMask = SuctionColliderTypeBlueSuction;
        self.blueNode.name = @"BlueSuction";
        [self.blueEffectNode addChild:self.blueNode];
        
        self.orangeNode = [SuctionNode newSuctionNode:[SKColor orangeColor] atPosition:CGPointMake(-64.f, 0)];
        self.orangeNode.physicsBody.categoryBitMask = SuctionColliderTypeOrangeSuction;
        self.orangeNode.name = @"OrangeSuction";
        [self.orangeEffectNode addChild:self.orangeNode];
    }
    return self;
}

+ (SKShapeNode *)newSuctionNode:(SKColor *)color atPosition:(CGPoint)position {
    SKShapeNode *node = [SKShapeNode node];
    node.fillColor = color;
    node.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(-16.f, -16.f, 32.f, 32.f)].CGPath;
    node.position = position;
    node.zPosition = 5;
    
    node.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:16.f];
    node.physicsBody.allowsRotation = NO;
    node.physicsBody.usesPreciseCollisionDetection = YES;
    node.physicsBody.collisionBitMask = SuctionColliderTypeWall;
    
    return node;
}

#pragma mark - Update
- (void)updateEffects {
//    [self.blueEffectNode.filter setValue:@(self.blueNode.zRotation) forKey:@"inputAngle"];
//    [self.orangeEffectNode.filter setValue:@(self.orangeNode.zRotation) forKey:@"inputAngle"];
}

#pragma mark - Health 
- (void)hurtOrangeNode {
    self.orangeHealth--;
}

- (void)hurtBlueNode {
    self.blueHealth--;
}

#pragma mark - Physics
- (void)toggleOrangeSuction {
    if (self.orangePinJoint) {
        [self.physicsWorld removeJoint:self.orangePinJoint];
        self.orangePinJoint = nil;
    } else {
        CGPoint redWorldPos = [self.parent convertPoint:self.orangeNode.position fromNode:self];
        self.orangePinJoint = [SKPhysicsJointPin jointWithBodyA:self.orangeNode.physicsBody
                                                       bodyB:self.parent.physicsBody
                                                      anchor:redWorldPos];
        [self.physicsWorld addJoint:self.orangePinJoint];
    }
    
    BOOL jointDisabled = (self.orangePinJoint == nil);
    self.orangeNode.alpha = jointDisabled ? 1.f : 0.3f;
    self.orangeNode.strokeColor = jointDisabled ? [SKColor clearColor] : [SKColor whiteColor];
    self.orangeEffectNode.shouldEnableEffects = jointDisabled;
}

- (void)toggleBlueSuction {
    if (self.bluePinJoint) {
        [self.physicsWorld removeJoint:self.bluePinJoint];
        self.bluePinJoint = nil;
    } else {
        CGPoint blueWorldPos = [self.parent convertPoint:self.blueNode.position fromNode:self];
        self.bluePinJoint = [SKPhysicsJointPin jointWithBodyA:self.blueNode.physicsBody
                                                        bodyB:self.parent.physicsBody
                                                       anchor:blueWorldPos];
        [self.physicsWorld addJoint:self.bluePinJoint];
    }
    
    BOOL jointDisabled = (self.bluePinJoint == nil);
    self.blueNode.alpha = jointDisabled ? 1.f : 0.3f;
    self.blueNode.strokeColor = jointDisabled ? [SKColor clearColor] : [SKColor whiteColor];
    self.blueEffectNode.shouldEnableEffects = jointDisabled;
}

- (void)accelerateOrangeNode {
    [self accelerateNode:self.orangeNode];
}

- (void)accelerateBlueNode {
    [self accelerateNode:self.blueNode];
}

- (void)accelerateNode:(SKNode *)node {
    [node.physicsBody applyImpulse:CGVectorMake(25, 0)];
}

@end
