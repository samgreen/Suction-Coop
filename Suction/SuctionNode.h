//
//  SuctionNode.h
//  Suction
//
//  Created by Sam Green on 8/1/14.
//  Copyright (c) 2014 Sam Green. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SuctionNode : SKNode

@property (nonatomic, readonly) SKShapeNode *blueNode;
@property (nonatomic, readonly) SKShapeNode *redNode;

@property (nonatomic, readonly) NSInteger blueHealth;
@property (nonatomic, readonly) NSInteger redHealth;

- (void)createJoint;

- (void)toggleRedSuction;
- (void)toggleBlueSuction;

- (void)accelerateRedNode;
- (void)accelerateBlueNode;

- (void)hurtRedNode;
- (void)hurtBlueNode;

@end
