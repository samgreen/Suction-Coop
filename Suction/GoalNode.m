//
//  GoalNode.m
//  Suction
//
//  Created by Sam Green on 8/2/14.
//  Copyright (c) 2014 Sam Green. All rights reserved.
//

#import "GoalNode.h"
#import "SKNode+ArchiveHelpers.h"
#import "SKEffectNode+CoreImageHelpers.h"

@interface GoalNode ()

@end

@implementation GoalNode

- (instancetype)init {
    self = [super init];
    if (self) {
        self.name = @"Goal";
        
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:64.f];
        self.physicsBody.dynamic = NO;
        self.physicsBody.categoryBitMask = SuctionColliderTypeGoal;
        self.physicsBody.collisionBitMask = SuctionColliderTypeNone;
        self.physicsBody.contactTestBitMask = SuctionColliderTypeOrangeSuction | SuctionColliderTypeBlueSuction;
        
#if (TARGET_IPHONE_SIMULATOR)
        SKShapeNode *shapeNode = [SKShapeNode shapeNodeWithCircleOfRadius:64.f];
        shapeNode.fillColor = [UIColor greenColor];
        [self addChild:shapeNode];
#else
        SKEffectNode *effectNode = [SKEffectNode nodeWithFilterNamed:@"CIBloom" andInputRadius:50];
        [self addChild:effectNode];
        
        SKEmitterNode *emitter = [SKEmitterNode loadArchive:@"GoalParticle"];
        [effectNode addChild:emitter];

#endif
    }
    return self;
}
@end
