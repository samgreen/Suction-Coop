//
//  GoalNode.m
//  Suction
//
//  Created by Sam Green on 8/2/14.
//  Copyright (c) 2014 Sam Green. All rights reserved.
//

#import "GoalNode.h"
#import "SKNode+ArchiveHelpers.h"

@interface GoalNode ()

@end

@implementation GoalNode

+ (instancetype)node {
    return [[self alloc] init];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.name = @"Goal";
        
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:64.f];
        self.physicsBody.affectedByGravity = NO;
        self.physicsBody.categoryBitMask = SuctionColliderTypeGoal;
        self.physicsBody.collisionBitMask = 0; // No collide
        self.physicsBody.contactTestBitMask = SuctionColliderTypeOrangeSuction | SuctionColliderTypeBlueSuction;
        
        SKEmitterNode *emitter = [SKEmitterNode loadArchive:@"MagicParticle"];
        [self addChild:emitter];
    }
    return self;
}
@end
