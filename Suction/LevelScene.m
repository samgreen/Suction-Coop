//
//  MyScene.m
//  Suction
//
//  Created by Sam Green on 7/31/14.
//  Copyright (c) 2014 Sam Green. All rights reserved.
//

#import "LevelScene.h"
#import "SuctionNode.h"
#import "WallNode.h"
#import "GoalNode.h"
#import "PainNode.h"
#import "SKNode+ArchiveHelpers.h"

@interface LevelScene () <SKPhysicsContactDelegate>

@property (nonatomic, strong) SKLabelNode *redHealthLabelNode;
@property (nonatomic, strong) SKLabelNode *blueHealthLabelNode;
@property (nonatomic, strong) SKLabelNode *gameOverLabelNode;

@property (nonatomic, strong) SKNode *gameLayerNode;
@property (nonatomic, strong) SKNode *interfaceLayerNode;

@property (nonatomic, strong) SuctionNode *suctionNode;
@property (nonatomic, strong) GoalNode *goalNode;

@property (nonatomic) BOOL reachedGoal;

@end

@implementation LevelScene

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.gameLayerNode = [SKNode node];
        [self addChild:self.gameLayerNode];
        
        self.interfaceLayerNode = [SKNode node];
        [self addChild:self.interfaceLayerNode];
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        self.physicsWorld.contactDelegate = self;
        
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        self.physicsBody.collisionBitMask = SuctionColliderTypeBlueSuction | SuctionColliderTypeRedSuction;
        self.physicsBody.categoryBitMask = SuctionColliderTypeWall;
        self.physicsBody.dynamic = NO;
    }
    return self;
}

#pragma mark - Init Methods
- (void)initUI {
    SKLabelNode *redSuctionLabelNode = [LevelScene newLabelNode:@"Suction" withFontColor:[SKColor redColor]];
    redSuctionLabelNode.position = CGPointMake(80, 192);
    [self addChild:redSuctionLabelNode];
    
    SKLabelNode *redForceLabelNode = [LevelScene newLabelNode:@"Apply Force" withFontColor:[SKColor redColor]];
    redForceLabelNode.position = CGPointMake(80, 576);
    [self addChild:redForceLabelNode];
    
    SKLabelNode *blueSuctionLabelNode = [LevelScene newLabelNode:@"Suction" withFontColor:[SKColor blueColor]];
    blueSuctionLabelNode.position = CGPointMake(944, 192);
    [self addChild:blueSuctionLabelNode];
    
    SKLabelNode *blueForceLabelNode = [LevelScene newLabelNode:@"Apply Force" withFontColor:[SKColor blueColor]];
    blueForceLabelNode.position = CGPointMake(944, 576);
    [self addChild:blueForceLabelNode];
    
    self.blueHealthLabelNode = [LevelScene newLabelNode:@"Health: 3" withFontColor:[SKColor blueColor]];
    self.blueHealthLabelNode.position = CGPointMake(944, 10);
    [self addChild:self.blueHealthLabelNode];
    
    self.redHealthLabelNode = [LevelScene newLabelNode:@"Health: 3" withFontColor:[SKColor redColor]];
    self.redHealthLabelNode.position = CGPointMake(80, 10);
    [self addChild:self.redHealthLabelNode];
    
    self.gameOverLabelNode = [LevelScene newLabelNode:@"" withFontColor:[SKColor whiteColor]];
    self.gameOverLabelNode.fontSize = 48.f;
    self.gameOverLabelNode.position = CGPointMake(CGRectGetWidth(self.frame) / 2,
                                                  CGRectGetHeight(self.frame) / 2);
    [self addChild:self.gameOverLabelNode];
}

- (void)initFixedJoint {
    // 1. Create a box to join the two, then add it below them
    SKShapeNode *boxNode = [SKShapeNode node];
    boxNode.name = @"SuctionBox";
    boxNode.zPosition = 10;
    boxNode.fillColor = [UIColor whiteColor];
    boxNode.path = [UIBezierPath bezierPathWithRect:CGRectMake(-64.f, -8.f, 128.f, 16.f)].CGPath;
    boxNode.position = CGPointZero;
    boxNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(128.f, 16.f)];
    // Collide with nothing
    boxNode.physicsBody.collisionBitMask = 0;
    boxNode.physicsBody.categoryBitMask = 0;
    boxNode.physicsBody.contactTestBitMask = 0;
    [self.suctionNode addChild:boxNode];
    
    // 2. Create a fixed joint between the blue node and the box
    CGPoint redWordPosition = [self convertPoint:self.suctionNode.redNode.position fromNode:self.suctionNode];
    SKPhysicsJointPin *redJoint = [SKPhysicsJointPin jointWithBodyA:boxNode.physicsBody
                                                              bodyB:self.suctionNode.redNode.physicsBody
                                                             anchor:redWordPosition];
    [self.physicsWorld addJoint:redJoint];
    
    // 3. Create a fixed joint between the red node and the box
    CGPoint blueWordPosition = [self convertPoint:self.suctionNode.blueNode.position fromNode:self.suctionNode];
    SKPhysicsJointPin *blueJoint = [SKPhysicsJointPin jointWithBodyA:boxNode.physicsBody
                                                               bodyB:self.suctionNode.blueNode.physicsBody
                                                              anchor:blueWordPosition];
    [self.physicsWorld addJoint:blueJoint];
}

- (void)initLRopeJoint {
    CGPoint redCenter = CGPointMake(self.suctionNode.redNode.position.x + 64.f, self.suctionNode.redNode.position.y);
    CGPoint blueCenter = CGPointMake(self.suctionNode.blueNode.position.x - 64.f, self.suctionNode.blueNode.position.y);
    CGPoint redPos = [self convertPoint:redCenter fromNode:self.suctionNode.redNode];
    CGPoint bluePos = [self convertPoint:blueCenter fromNode:self.suctionNode.blueNode];
    SKPhysicsJointLimit *limitJoint = [SKPhysicsJointLimit jointWithBodyA:self.suctionNode.redNode.physicsBody
                                                                    bodyB:self.suctionNode.blueNode.physicsBody
                                                                  anchorA:redPos
                                                                  anchorB:bluePos];
    [self.physicsWorld addJoint:limitJoint];
}

- (void)initWithLevel:(NSUInteger)level {
    // Load the level archive for this level
    NSString *name = [NSString stringWithFormat:@"Level-%lu", (unsigned long)level];
    SKScene *scene = [LevelScene loadArchive:name];
    if (scene == nil) {
        self.level = 1;
        return;
    }
    
    // Start with a clean slate
    [self removeAllChildren];
    self.reachedGoal = NO;
    
    // 1. Load walls
    [scene enumerateChildNodesWithName:@"Wall" usingBlock:^(SKNode *node, BOOL *stop) {
        SKSpriteNode *spriteNode = (SKSpriteNode *)node;
        WallNode *wall = [WallNode nodeWithSize:spriteNode.size];
        wall.zRotation = node.zRotation;
        wall.position = CGPointMake(node.frame.origin.x + node.frame.size.width / 2,
                                    node.frame.origin.y + node.frame.size.height / 2);
        [self addChild:wall];
    }];
    
    // 2. Load pain nodes
    [scene enumerateChildNodesWithName:@"Pain" usingBlock:^(SKNode *node, BOOL *stop) {
        SKSpriteNode *spriteNode = (SKSpriteNode *)node;
        PainNode *pain = [PainNode nodeWithSize:spriteNode.size];
        pain.zRotation = node.zRotation;
        pain.position = CGPointMake(node.frame.origin.x + node.frame.size.width / 2,
                                    node.frame.origin.y + node.frame.size.height / 2);
        [self addChild:pain];
    }];
    
    // 3. Load goal
    SKNode *goal  = (GoalNode *)[scene childNodeWithName:@"Goal"];
    self.goalNode = [GoalNode node];
    self.goalNode.position = goal.position;
    [self addChild:self.goalNode];
    
    
    // 4. Load Suction
    SKNode *suction = (SuctionNode *)[scene childNodeWithName:@"Suction"];
    self.suctionNode = [SuctionNode node];
    self.suctionNode.position = suction.position;
    self.suctionNode.zRotation = suction.zRotation;
    [self addChild:self.suctionNode];
    
    // 5. Create joint
//    [self initLRopeJoint];
    [self initFixedJoint];
    
    // 6. Reload UI
    [self initUI];
}

#pragma mark - Custom Setters
- (void)setLevel:(NSUInteger)level {
    _level = level;
    
    [self initWithLevel:self.level];
}

#pragma mark - Input
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.paused) {
        if (self.reachedGoal) {
            // Load next level
            self.level = self.level + 1;
        } else {
            // Reload this level
            self.level = self.level;
        }
        self.paused = NO;
        return;
    }
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    static const CGFloat kRedMaxTouchX = 120.f;
    static const CGFloat kBlueMinTouchX = 904.f;
    static const CGFloat kMidTouchY = 384.f;
    
    if (location.x < kRedMaxTouchX) {
        if (location.y < kMidTouchY) {
            [self.suctionNode toggleRedSuction];
        } else {
            [self.suctionNode accelerateRedNode];
        }
    } else if (location.x > kBlueMinTouchX) {
        if (location.y < kMidTouchY) {
            [self.suctionNode toggleBlueSuction];
        } else {
            [self.suctionNode accelerateBlueNode];
        }
    } else {
        NSLog(@"Touch %@", NSStringFromCGPoint(location));
    }
}

#pragma mark - Update
- (void)update:(CFTimeInterval)currentTime {

}

- (void)updateUI {
    self.redHealthLabelNode.text = [NSString stringWithFormat:@"Health: %lu", (unsigned long)self.suctionNode.redHealth];
    self.blueHealthLabelNode.text = [NSString stringWithFormat:@"Health: %lu", (unsigned long)self.suctionNode.blueHealth];
    
    if (self.suctionNode.redHealth <= 0 || self.suctionNode.blueHealth <= 0) {
        self.gameOverLabelNode.text = @"Game Over!";
        self.paused = YES;
    } else if (self.reachedGoal) {
        self.gameOverLabelNode.text = @"You Win!";
        self.paused = YES;
    }
}

#pragma mark - Physics Delegate
- (void)didBeginContact:(SKPhysicsContact *)contact {
    SKNode *nodeA = contact.bodyA.node;
    SKNode *nodeB = contact.bodyB.node;
    
    // Did we hit a pain node?
    if ([nodeA.name isEqualToString:@"Pain"]) {
        
        // Determine what color node hit the pain node
        if ([nodeB.name isEqualToString:@"BlueSuction"]) {
            [self.suctionNode hurtBlueNode];
        } else if ([nodeB.name isEqualToString:@"RedSuction"]) {
            [self.suctionNode hurtRedNode];
        }
        [self updateUI];
    } else if ([nodeA.name isEqualToString:@"Goal"]) {
        self.reachedGoal = YES;
        self.paused = YES;
        [self updateUI];
    } else {
        NSLog(@"Began contact (%@, %@)", nodeA.name, nodeB.name);
    }
}

- (void)didEndContact:(SKPhysicsContact *)contact {
    
}

#pragma mark - Helpers
+ (SKLabelNode *)newLabelNode:(NSString *)text withFontColor:(SKColor *)fontColor {
    SKLabelNode *labelNode = [SKLabelNode labelNodeWithFontNamed:@"Helvetica-Neue"];
    labelNode.zPosition = 1000;
    labelNode.fontSize = 20.f;
    labelNode.fontColor = fontColor;
    labelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    labelNode.text = text;
    return labelNode;
}

@end
