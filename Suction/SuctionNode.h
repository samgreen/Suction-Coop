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

- (void)createJoint;

- (void)toggleRedSuction;
- (void)toggleBlueSuction;

- (void)accelerateRedNode;
- (void)accelerateBlueNode;

@end
