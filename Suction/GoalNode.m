//
//  GoalNode.m
//  Suction
//
//  Created by Sam Green on 8/2/14.
//  Copyright (c) 2014 Sam Green. All rights reserved.
//

#import "GoalNode.h"

@interface GoalNode ()

@property (nonatomic, strong) SKShapeNode *shapeNode;

@end

@implementation GoalNode

+ (instancetype)node {
    return [[self alloc] init];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.shapeNode = [SKShapeNode node];
        self.shapeNode.name = @"Goal";
        self.shapeNode.fillColor = [UIColor greenColor];
        self.shapeNode.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(-64.f, -64.f, 128.f, 128.f)].CGPath;
        
        self.shapeNode.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:64.f];
        self.shapeNode.physicsBody.dynamic = NO;
        self.shapeNode.physicsBody.categoryBitMask = SuctionColliderTypeGoal;
        self.shapeNode.physicsBody.collisionBitMask = 0; // No collide
        self.shapeNode.physicsBody.contactTestBitMask = SuctionColliderTypeRedSuction | SuctionColliderTypeBlueSuction;
        
        [self addChild:self.shapeNode];
    }
    return self;
}
@end
