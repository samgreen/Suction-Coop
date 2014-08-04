//
//  GravityNode.m
//  Suction
//
//  Created by Sam Green on 8/4/14.
//  Copyright (c) 2014 Sam Green. All rights reserved.
//

#import "GravityNode.h"
#import "TargetConditionals.h"
#import "SKEffectNode+CoreImageHelpers.h"
#import "SKNode+ArchiveHelpers.h"

@interface GravityNode ()

@property (nonatomic, strong) SKSpriteNode *spriteNode;
@property (nonatomic, strong) SKShapeNode *shapeNode;

@end

@implementation GravityNode

- (instancetype)init {
    self = [super init];
    if (self) {
        SKEffectNode *effectNode = [SKEffectNode nodeWithFilterNamed:@"CIVortexDistortion"];
        [effectNode.filter setValue:@(70) forKey:kCIInputRadiusKey];
        [effectNode.filter setValue:@(360 * 1) forKey:kCIInputAngleKey];
        [self addChild:effectNode];
        
        self.spriteNode = [SKSpriteNode spriteNodeWithColor:[SKColor blackColor]
                                                       size:CGSizeMake(32.f, 32.f)];
        [effectNode addChild:self.spriteNode];
        
        SKAction *rotateAction = [SKAction rotateByAngle:M_2_PI duration:0.5f];
        SKAction *repeatAction = [SKAction repeatActionForever:rotateAction];
        [self.spriteNode runAction:repeatAction];
        
        if (NSClassFromString(@"SKFieldNode")) {
            [self addRadialGravityField];
            
#if !(TARGET_IPHONE_SIMULATOR)
            SKEmitterNode *emitterNode = [SKEmitterNode loadArchive:@"GravityParticle"];
            if ([emitterNode respondsToSelector:@selector(fieldBitMask)]) {
                emitterNode.fieldBitMask = SuctionFieldTypeRadialGravity;
            }
            [self addChild:emitterNode];
#endif
        }
    }
    return self;
}

- (void)addRadialGravityField {
    SKFieldNode *fieldNode = [SKFieldNode radialGravityField];
    fieldNode.categoryBitMask = SuctionFieldTypeRadialGravity;
    fieldNode.strength = 9.8f;
    fieldNode.minimumRadius = 16;
    fieldNode.falloff = 1;
    [self addChild:fieldNode];
}

@end
