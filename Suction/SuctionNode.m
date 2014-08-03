//
//  SuctionNode.m
//  Suction
//
//  Created by Sam Green on 8/1/14.
//  Copyright (c) 2014 Sam Green. All rights reserved.
//

#import "SuctionNode.h"

@interface SuctionNode ()

@property (nonatomic, strong) SKShapeNode *blueNode;
@property (nonatomic, strong) SKShapeNode *redNode;

@property (nonatomic) NSUInteger redHealth;
@property (nonatomic) NSUInteger blueHealth;

@end

@implementation SuctionNode

+ (instancetype)node {
    return [[self alloc] init];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.blueHealth = 3;
        self.blueNode = [SuctionNode newSuctionNode:[SKColor blueColor] atPosition:CGPointMake(64.f, 0)];
        self.blueNode.physicsBody.categoryBitMask = SuctionColliderTypeBlueSuction;
        self.blueNode.name = @"BlueSuction";
        [self addChild:self.blueNode];
        [self toggleBlueSuction];
        
        self.redHealth = 3;
        self.redNode = [SuctionNode newSuctionNode:[SKColor redColor] atPosition:CGPointMake(-64.f, 0)];
        self.redNode.physicsBody.categoryBitMask = SuctionColliderTypeRedSuction;
        self.redNode.name = @"RedSuction";
        [self addChild:self.redNode];
        [self toggleRedSuction];
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
    node.physicsBody.usesPreciseCollisionDetection = YES;
    node.physicsBody.categoryBitMask = SuctionColliderTypeWall;
    node.physicsBody.collisionBitMask = SuctionColliderTypeWall;
    
    return node;
}

- (void)createJoint {
    
}

#pragma mark - Health 
- (void)hurtRedNode {
    self.redHealth--;
}

- (void)hurtBlueNode {
    self.blueHealth--;
}

#pragma mark - Physics
- (void)toggleRedSuction {
    self.redNode.physicsBody.dynamic = !self.redNode.physicsBody.dynamic;
}

- (void)toggleBlueSuction {
    self.blueNode.physicsBody.dynamic = !self.blueNode.physicsBody.dynamic;
}

- (void)accelerateRedNode {
    [self accelerateNode:self.redNode];
}

- (void)accelerateBlueNode {
    [self accelerateNode:self.blueNode];
}

- (void)accelerateNode:(SKNode *)node {
    if (!node.physicsBody.dynamic) return;
    
    [node.physicsBody applyImpulse:CGVectorMake(100, 0)];
}

@end
