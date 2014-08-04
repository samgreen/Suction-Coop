//
//  HealthNode.m
//  Suction
//
//  Created by Sam Green on 8/4/14.
//  Copyright (c) 2014 Sam Green. All rights reserved.
//

#import "HealthNode.h"

@implementation HealthNode

- (instancetype)init {
    self = [super init];
    if (self) {
        self.maxHealth = 3;
        self.health = self.maxHealth;
    }
    return self;
}

- (void)setColor:(SKColor *)color {
    _color = color;
    
    self.maxHealth = 3;
    self.health = self.maxHealth;
}

- (void)setMaxHealth:(NSUInteger)maxHealth {
    _maxHealth = maxHealth;
    
    [self removeAllChildren];
    
    for (NSInteger i = 0; i < self.maxHealth; i++) {
        [self addEmptyHeartNode:CGPointMake(48 * i, 0)];
    }
}

- (void)setHealth:(NSUInteger)health {
    _health = health;
    
    [self removeChildrenInArray:[self fullHearts]];
    
    for (NSInteger i = 0; i < self.health; i++) {
        [self addFullHeartNode:CGPointMake(48 * i, 0)];
    }
}

- (NSArray *)fullHearts {
    NSMutableArray *array = [NSMutableArray array];
    [self enumerateChildNodesWithName:@"Full" usingBlock:^(SKNode *node, BOOL *stop) {
        [array addObject:node];
    }];
    return [array copy];
}

- (SKSpriteNode *)addEmptyHeartNode:(CGPoint)position {
    SKSpriteNode *heart = [SKSpriteNode spriteNodeWithImageNamed:@"heart_empty"];
    heart.name = @"Empty";
    heart.zPosition = 900;
    heart.position = position;
    heart.alpha = 0.3f;
    heart.size = CGSizeMake(heart.size.width * 1.5f, heart.size.height * 1.5f);
    heart.color = self.color;
    heart.colorBlendFactor = 0.8f;
    [self addChild:heart];
    
    return heart;
}

- (SKSpriteNode *)addFullHeartNode:(CGPoint)position {
    SKSpriteNode *heart = [SKSpriteNode spriteNodeWithImageNamed:@"heart"];
    heart.name = @"Full";
    heart.zPosition = 1000;
    heart.position = position;
    heart.size = CGSizeMake(heart.size.width * 1.5f, heart.size.height * 1.5f);
    heart.color = self.color;
    heart.colorBlendFactor = 0.2f;
    [self addChild:heart];
    
    return heart;
}

@end
