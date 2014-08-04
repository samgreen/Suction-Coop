//
//  PainNode.m
//  Suction
//
//  Created by Sam Green on 8/2/14.
//  Copyright (c) 2014 Sam Green. All rights reserved.
//

#import "PainNode.h"

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
        self.shapeNode = [SKShapeNode node];
        self.shapeNode.name = @"Pain";
        self.shapeNode.fillColor = [UIColor orangeColor];
        CGRect rect = CGRectMake(-size.width / 2, -size.height / 2, size.width, size.height);
        self.shapeNode.path = [UIBezierPath bezierPathWithRect:rect].CGPath;
        
        self.shapeNode.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:rect];
        self.shapeNode.physicsBody.categoryBitMask = SuctionColliderTypePain;
        self.shapeNode.physicsBody.collisionBitMask = 0; // No collide
        self.shapeNode.physicsBody.contactTestBitMask = SuctionColliderTypeRedSuction | SuctionColliderTypeBlueSuction;
        
        [self addChild:self.shapeNode];
    }
    return self;
}

@end
