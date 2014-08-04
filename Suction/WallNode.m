//
//  WallNode.m
//  Suction
//
//  Created by Sam Green on 8/3/14.
//  Copyright (c) 2014 Sam Green. All rights reserved.
//

#import "WallNode.h"

@interface WallNode ()
@property (nonatomic, strong) SKSpriteNode *spriteNode;
@end

@implementation WallNode

+ (instancetype)nodeWithSize:(CGSize)size {
    return [[self alloc] initWithSize:size];
}

- (instancetype)initWithSize:(CGSize)size {
    self = [super init];
    if (self) {
        CGRect rect = CGRectMake(-size.width / 2, -size.height / 2, size.width, size.height);
        
        self.spriteNode = [SKSpriteNode spriteNodeWithImageNamed:@"wall"];
        self.spriteNode.name = @"Wall";
        CGRect unitRect = CGRectMake(0, 0,
                                     size.width / self.spriteNode.texture.size.width,
                                     size.height / self.spriteNode.texture.size.height);
        self.spriteNode.texture = [SKTexture textureWithRect:unitRect inTexture:self.spriteNode.texture];
        self.spriteNode.size = size;
        
        // Generate normal texture if possible
//        if ([self.spriteNode respondsToSelector:@selector(normalTexture)]) {
//            self.spriteNode.normalTexture = [self.spriteNode.texture textureByGeneratingNormalMapWithSmoothness:0.f
//                                                                                                       contrast:0.f];
//        }
        
        self.spriteNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rect.size];
        self.spriteNode.physicsBody.dynamic = NO;
        self.spriteNode.physicsBody.categoryBitMask = SuctionColliderTypeWall;
        self.spriteNode.physicsBody.collisionBitMask = SuctionColliderTypeOrangeSuction | SuctionColliderTypeBlueSuction;
        
        [self addChild:self.spriteNode];
    }
    return self;
}

@end
