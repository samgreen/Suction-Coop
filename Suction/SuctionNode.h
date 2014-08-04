//
//  SuctionNode.h
//  Suction
//
//  Created by Sam Green on 8/1/14.
//  Copyright (c) 2014 Sam Green. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SuctionNode : SKNode

@property (nonatomic, weak) SKPhysicsWorld *physicsWorld;

@property (nonatomic, readonly) SKShapeNode *blueNode;
@property (nonatomic, readonly) SKShapeNode *orangeNode;

@property (nonatomic, readonly) NSInteger blueHealth;
@property (nonatomic, readonly) NSInteger orangeHealth;

- (void)toggleOrangeSuction;
- (void)toggleBlueSuction;

- (void)accelerateOrangeNode;
- (void)accelerateBlueNode;

- (void)hurtOrangeNode;
- (void)hurtBlueNode;

@end
