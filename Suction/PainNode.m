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

@property (nonatomic, strong) SKShapeNode *shapeNode;

@end

@implementation PainNode

+ (instancetype)nodeWithSize:(CGSize)size {
    return [[self alloc] initWithSize:size];
}

- (instancetype)initWithSize:(CGSize)size {
    self = [super init];
    if (self) {
        CGRect rect = CGRectMake(-size.width / 2, -size.height / 2, size.width, size.height);
        
        self.shapeNode = [SKShapeNode node];
        self.shapeNode.name = @"Pain";
        self.shapeNode.fillColor = [UIColor redColor];
        self.shapeNode.alpha = 0.3f;
        self.shapeNode.path = [UIBezierPath bezierPathWithRect:rect].CGPath;
        
        self.shapeNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rect.size];
        self.shapeNode.physicsBody.dynamic = NO;
        self.shapeNode.physicsBody.categoryBitMask = SuctionColliderTypePain;
        self.shapeNode.physicsBody.collisionBitMask = 0; // No collide
        self.shapeNode.physicsBody.contactTestBitMask = SuctionColliderTypeOrangeSuction | SuctionColliderTypeBlueSuction;
        
        [self addChild:self.shapeNode];
        
        SKEmitterNode *emitter = [SKEmitterNode loadArchive:@"FireParticle"];
        emitter.particlePosition = CGPointZero;
        emitter.particlePositionRange = CGVectorMake(size.width, size.height);
        [self addChild:emitter];
    }
    return self;
}

@end
