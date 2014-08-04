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
        self.physicsBody.affectedByGravity = NO;
        self.physicsBody.categoryBitMask = SuctionColliderTypeGoal;
        self.physicsBody.collisionBitMask = SuctionColliderTypeNone;
        self.physicsBody.contactTestBitMask = SuctionColliderTypeOrangeSuction | SuctionColliderTypeBlueSuction;
        
        SKEffectNode *effectNode = [SKEffectNode nodeWithFilterNamed:@"CIBloom" andInputRadius:50];
        [self addChild:effectNode];
        
        SKEmitterNode *emitter = [SKEmitterNode loadArchive:@"MagicParticle"];
        [effectNode addChild:emitter];
    }
    return self;
}
@end
