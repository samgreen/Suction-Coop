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

@end

@implementation SuctionNode

+ (instancetype)node {
    return [[self alloc] init];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.blueNode = [SuctionNode newSuctionNode:[SKColor blueColor] atPosition:CGPointMake(64.f, 0)];
        [self addChild:self.blueNode];
        
        self.redNode = [SuctionNode newSuctionNode:[SKColor redColor] atPosition:CGPointMake(-64.f, 0)];
        [self addChild:self.redNode];
    }
    return self;
}

+ (SKShapeNode *)newSuctionNode:(SKColor *)color atPosition:(CGPoint)position {
    SKShapeNode *node = [SKShapeNode node];
    node.fillColor = color;
    node.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(-16.f, -16.f, 32.f, 32.f)].CGPath;
    node.position = position;
    
    node.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:16.f];
    
    return node;
}

- (void)createJoint {
    
}

- (void)toggleRedSuction {
    self.redNode.physicsBody.dynamic = !self.redNode.physicsBody.dynamic;
}

- (void)toggleBlueSuction {
    self.blueNode.physicsBody.dynamic = !self.blueNode.physicsBody.dynamic;
}

- (void)accelerateRedNode {
    if (!self.redNode.physicsBody.dynamic) return;
    
    [self.redNode.physicsBody applyImpulse:CGVectorMake(100, 0)];
}

- (void)accelerateBlueNode {
    if (!self.blueNode.physicsBody.dynamic) return;
    
    [self.blueNode.physicsBody applyImpulse:CGVectorMake(100, 0)];
}

@end
