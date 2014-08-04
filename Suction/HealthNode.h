//
//  HealthNode.h
//  Suction
//
//  Created by Sam Green on 8/4/14.
//  Copyright (c) 2014 Sam Green. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface HealthNode : SKNode

@property (nonatomic) NSUInteger health;
@property (nonatomic) NSUInteger maxHealth;
@property (nonatomic, strong) SKColor *color;

@end
