//
//  WallNode.m
//  Suction
//
//  Created by Sam Green on 8/3/14.
//  Copyright (c) 2014 Sam Green. All rights reserved.
//

#import "WallNode.h"

@interface WallNode ()
@property (nonatomic, strong) SKShapeNode *shapeNode;
@end

@implementation WallNode

+ (instancetype)nodeWithSize:(CGSize)size {
    return [[self alloc] initWithSize:size];
}

- (instancetype)initWithSize:(CGSize)size {
    self = [super init];
    if (self) {
        self.shapeNode = [SKShapeNode node];
        self.shapeNode.name = @"Wall";
        self.shapeNode.fillColor = [UIColor grayColor];
        self.shapeNode.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(-size.width / 2, -size.height / 2, size.width, size.height) cornerRadius:3.f].CGPath;
        
        self.shapeNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:size];
        self.shapeNode.physicsBody.dynamic = NO;
        self.shapeNode.physicsBody.categoryBitMask = SuctionColliderTypeWall;
        self.shapeNode.physicsBody.collisionBitMask = SuctionColliderTypeRedSuction | SuctionColliderTypeBlueSuction;
        
        [self addChild:self.shapeNode];
    }
    return self;
}

@end
