//
//  PainNode.m
//  Suction
//
//  Created by Sam Green on 8/2/14.
//  Copyright (c) 2014 Sam Green. All rights reserved.
//

#import "PainNode.h"
#import "SKNode+ArchiveHelpers.h"

@interface PainNode ()

@end

@implementation PainNode

+ (instancetype)nodeWithSize:(CGSize)size {
    return [[self alloc] initWithSize:size];
}

- (instancetype)initWithSize:(CGSize)size {
    self = [super init];
    if (self) {
        self.name = @"Pain";
        
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:size];
        self.physicsBody.dynamic = NO;
        self.physicsBody.categoryBitMask = SuctionColliderTypePain;
        self.physicsBody.collisionBitMask = SuctionColliderTypeNone;
        self.physicsBody.contactTestBitMask = SuctionColliderTypeOrangeSuction | SuctionColliderTypeBlueSuction;
        
        SKEmitterNode *emitter = [SKEmitterNode loadArchive:@"FireParticle"];
        emitter.particlePosition = CGPointZero;
        emitter.particlePositionRange = CGVectorMake(size.width, size.height);
        emitter.particleBirthRate = size.height * size.width * 0.05f;
        [self addChild:emitter];
    }
    return self;
}

@end
