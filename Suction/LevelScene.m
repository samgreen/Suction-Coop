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
#import "GravityNode.h"
#import "HealthNode.h"
#import "SKNode+ArchiveHelpers.h"

#import <Kamcord/Kamcord.h>

@interface LevelScene () <SKPhysicsContactDelegate>

@property (nonatomic, strong) SKLabelNode *gameOverLabelNode;

@property (nonatomic, strong) HealthNode *orangeHealthNode;
@property (nonatomic, strong) HealthNode *blueHealthNode;

@property (nonatomic, strong) SKNode *gameLayerNode;
@property (nonatomic, strong) SKNode *interfaceLayerNode;

@property (nonatomic, strong) SuctionNode *suctionNode;
@property (nonatomic, strong) GoalNode *goalNode;

@property (nonatomic) BOOL reachedGoal;

@end

@implementation LevelScene

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.name = @"Scene";
        self.scaleMode = SKSceneScaleModeAspectFill;
        
        self.gameLayerNode = [SKNode node];
        [self addChild:self.gameLayerNode];
        
        self.interfaceLayerNode = [SKNode node];
        [self addChild:self.interfaceLayerNode];
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        self.physicsWorld.contactDelegate = self;
        
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        self.physicsBody.categoryBitMask = SuctionColliderTypeEdgeWall;
        self.physicsBody.collisionBitMask = SuctionColliderTypeBlueSuction | SuctionColliderTypeOrangeSuction;
        self.physicsBody.contactTestBitMask = self.physicsBody.collisionBitMask;
    }
    return self;
}

#pragma mark - Init Methods
- (void)initUI {
    SKLabelNode *orangeSuctionLabelNode = [LevelScene newControlNode:@"Suction" withFontColor:[SKColor orangeColor]];
    orangeSuctionLabelNode.zRotation = -M_PI_2;
    orangeSuctionLabelNode.position = CGPointMake(20, 192);
    [self addChild:orangeSuctionLabelNode];
    
    SKLabelNode *orangeForceLabelNode = [LevelScene newControlNode:@"Force" withFontColor:[SKColor orangeColor]];
    orangeForceLabelNode.zRotation = -M_PI_2;
    orangeForceLabelNode.position = CGPointMake(20, 576);
    [self addChild:orangeForceLabelNode];
    
    SKLabelNode *blueSuctionLabelNode = [LevelScene newControlNode:@"Suction" withFontColor:[SKColor blueColor]];
    blueSuctionLabelNode.position = CGPointMake(1004, 192);
    blueSuctionLabelNode.zRotation = M_PI_2;
    [self addChild:blueSuctionLabelNode];
    
    SKLabelNode *blueForceLabelNode = [LevelScene newControlNode:@"Force" withFontColor:[SKColor blueColor]];
    blueForceLabelNode.zRotation = M_PI_2;
    blueForceLabelNode.position = CGPointMake(1004, 576);
    [self addChild:blueForceLabelNode];
    
    self.gameOverLabelNode = [LevelScene newLabelNode:@"" withFontColor:[SKColor whiteColor]];
    self.gameOverLabelNode.fontName = @"Superclarendon-BlackItalic";
    self.gameOverLabelNode.zRotation = M_PI_4 * 0.3f;
    self.gameOverLabelNode.fontSize = 64.f;
    self.gameOverLabelNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:self.gameOverLabelNode];
    
    self.orangeHealthNode = [HealthNode node];
    self.orangeHealthNode.color = [SKColor orangeColor];
    self.orangeHealthNode.position = CGPointMake(50, CGRectGetMidY(self.frame) + 48.f);
    self.orangeHealthNode.zRotation = -M_PI_2;
    [self addChild:self.orangeHealthNode];
    
    self.blueHealthNode = [HealthNode node];
    self.blueHealthNode.color = [SKColor blueColor];
    self.blueHealthNode.position = CGPointMake(974, CGRectGetMidY(self.frame) - 48.f);
    self.blueHealthNode.zRotation = M_PI_2;
    [self addChild:self.blueHealthNode];
}

- (void)initFixedJoint {
    // 1. Create a box to join the two, then add it below them
    SKShapeNode *boxNode = [SKShapeNode node];
    boxNode.name = @"SuctionBox";
    boxNode.zPosition = 10;
    boxNode.fillColor = [UIColor whiteColor];
    boxNode.path = [UIBezierPath bezierPathWithRect:CGRectMake(-48.f, -4.f, 96.f, 8.f)].CGPath;
    boxNode.position = CGPointZero;
    boxNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(96.f, 8.f)];
    // Collide with nothing
    boxNode.physicsBody.collisionBitMask = SuctionColliderTypeNone;
    boxNode.physicsBody.categoryBitMask = SuctionColliderTypeNone;
    boxNode.physicsBody.contactTestBitMask = SuctionColliderTypeNone;
    [self.suctionNode addChild:boxNode];
    
    // 2. Create a fixed joint between the blue node and the box
    CGPoint orangeWorldPosition = [self convertPoint:self.suctionNode.orangeNode.position fromNode:self.suctionNode];
    SKPhysicsJointPin *orangeJoint = [SKPhysicsJointPin jointWithBodyA:boxNode.physicsBody
                                                              bodyB:self.suctionNode.orangeNode.physicsBody
                                                             anchor:orangeWorldPosition];
    [self.physicsWorld addJoint:orangeJoint];
    
    // 3. Create a fixed joint between the orange node and the box
    CGPoint blueWordPosition = [self convertPoint:self.suctionNode.blueNode.position fromNode:self.suctionNode];
    SKPhysicsJointPin *blueJoint = [SKPhysicsJointPin jointWithBodyA:boxNode.physicsBody
                                                               bodyB:self.suctionNode.blueNode.physicsBody
                                                              anchor:blueWordPosition];
    [self.physicsWorld addJoint:blueJoint];
}

- (void)initRopeJoint {
    CGPoint orangeCenter = CGPointMake(self.suctionNode.orangeNode.position.x + 64.f, self.suctionNode.orangeNode.position.y);
    CGPoint blueCenter = CGPointMake(self.suctionNode.blueNode.position.x - 64.f, self.suctionNode.blueNode.position.y);
    CGPoint orangeWorldPos = [self convertPoint:orangeCenter fromNode:self.suctionNode.orangeNode];
    CGPoint blueWorldPos = [self convertPoint:blueCenter fromNode:self.suctionNode.blueNode];
    SKPhysicsJointLimit *limitJoint = [SKPhysicsJointLimit jointWithBodyA:self.suctionNode.orangeNode.physicsBody
                                                                    bodyB:self.suctionNode.blueNode.physicsBody
                                                                  anchorA:orangeWorldPos
                                                                  anchorB:blueWorldPos];
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
    
    // Level title
    SKLabelNode *titleLabelNode = [LevelScene newLabelNode:name withFontColor:[SKColor whiteColor]];
    titleLabelNode.fontName = @"Superclarendon-Regular";
    titleLabelNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame) - 40);
    [self addChild:titleLabelNode];
    
    // Load background
    SKSpriteNode *backgroundNode = [SKSpriteNode spriteNodeWithImageNamed:@"woodbg"];
    // Enable normal mapping if possible
//    if ([backgroundNode respondsToSelector:@selector(normalTexture)]) {
//        backgroundNode.normalTexture = [backgroundNode.texture textureByGeneratingNormalMapWithSmoothness:1
//                                                                                                 contrast:1];
//    }
    backgroundNode.anchorPoint = CGPointZero;
    [self addChild:backgroundNode];
    
    // Load walls
    [scene enumerateChildNodesWithName:@"Wall" usingBlock:^(SKNode *node, BOOL *stop) {
        SKSpriteNode *spriteNode = (SKSpriteNode *)node;
        WallNode *wall = [WallNode nodeWithSize:spriteNode.size];
        wall.zRotation = node.zRotation;
        wall.position = CGPointMake(node.frame.origin.x + node.frame.size.width / 2,
                                    node.frame.origin.y + node.frame.size.height / 2);
        [self addChild:wall];
    }];
    
    // Load pain nodes
    [scene enumerateChildNodesWithName:@"Pain" usingBlock:^(SKNode *node, BOOL *stop) {
        SKSpriteNode *spriteNode = (SKSpriteNode *)node;
        PainNode *pain = [PainNode nodeWithSize:spriteNode.size];
        pain.zRotation = node.zRotation;
        pain.position = CGPointMake(node.frame.origin.x + node.frame.size.width / 2,
                                    node.frame.origin.y + node.frame.size.height / 2);
        [self addChild:pain];
    }];
    
    // Load gravity nodes
    [scene enumerateChildNodesWithName:@"Gravity" usingBlock:^(SKNode *node, BOOL *stop) {
        GravityNode *gravity = [GravityNode node];
        gravity.position = CGPointMake(node.frame.origin.x + node.frame.size.width / 2,
                                       node.frame.origin.y + node.frame.size.height / 2);
        [self addChild:gravity];
    }];
    
    // Load goal
    SKNode *goal  = (GoalNode *)[scene childNodeWithName:@"Goal"];
    self.goalNode = [GoalNode node];
    self.goalNode.position = goal.position;
    [self addChild:self.goalNode];
    
    
    // Load Suction
    SKNode *suction = (SuctionNode *)[scene childNodeWithName:@"Suction"];
    self.suctionNode = [SuctionNode node];
    self.suctionNode.physicsWorld = self.physicsWorld;
    self.suctionNode.position = suction.position;
    self.suctionNode.zRotation = suction.zRotation;
    [self addChild:self.suctionNode];
    [self.suctionNode toggleBlueSuction];
    [self.suctionNode toggleOrangeSuction];
    
    // Create joint
    //[self initRopeJoint];
    [self initFixedJoint];
    
    // Reload UI
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

    [self startRecording];
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    static const CGFloat kOrangeMaxTouchX = 120.f;
    static const CGFloat kBlueMinTouchX = 904.f;
    static const CGFloat kMidTouchY = 384.f;
    
    if (location.x < kOrangeMaxTouchX) {
        if (location.y < kMidTouchY) {
            [self.suctionNode toggleOrangeSuction];
        } else {
            [self.suctionNode accelerateOrangeNode];
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
    self.orangeHealthNode.health = self.suctionNode.orangeHealth;
    self.blueHealthNode.health = self.suctionNode.blueHealth;
    
    BOOL orangeDied = (self.suctionNode.orangeHealth <= 0);
    BOOL blueDied = (self.suctionNode.blueHealth <= 0);
    if (orangeDied || blueDied) {
        self.gameOverLabelNode.text = orangeDied ? @"Orange Died!" : @"Blue Died!";
        self.gameOverLabelNode.fontColor = orangeDied ? [SKColor orangeColor] : [SKColor blueColor];
        self.paused = YES;
        [self stopRecording];
    } else if (self.reachedGoal) {
        self.gameOverLabelNode.text = @"You Win!";
        self.gameOverLabelNode.fontColor = [SKColor greenColor];
        self.paused = YES;
        [self stopRecording];
    }
}

#pragma mark Physics
- (void)didSimulatePhysics {
    [self.suctionNode updateEffects];
    
    if (!CGRectIntersectsRect(self.frame, [self.suctionNode calculateAccumulatedFrame])) {
        self.gameOverLabelNode.text = @"You fell in to the abyss!";
        self.gameOverLabelNode.fontColor = [UIColor whiteColor];
        self.paused = YES;
    }
}

#pragma mark - Physics Delegate
- (void)didBeginContact:(SKPhysicsContact *)contact {
    SKNode *nodeA = contact.bodyA.node;
    SKNode *nodeB = contact.bodyB.node;
    NSString *nameA = nodeA.name;
    NSString *nameB = nodeB.name;
    
    // Did we hit a pain node?
    if ([nameA isEqualToString:@"Pain"] || [nameB isEqualToString:@"Pain"]) {
        
        // Determine what color node hit the pain node
        if ([nameA isEqualToString:@"BlueSuction"] || [nameB isEqualToString:@"BlueSuction"]) {
            [self.suctionNode hurtBlueNode];
        } else if ([nameA isEqualToString:@"OrangeSuction"] || [nameB isEqualToString:@"OrangeSuction"]) {
            [self.suctionNode hurtOrangeNode];
        }
        [self updateUI];
    } else if ([nameA isEqualToString:@"Goal"] || [nameB isEqualToString:@"Goal"]) {
        self.reachedGoal = YES;
        [self updateUI];
    } else if ([nameA isEqualToString:@"Scene"] || [nameB isEqualToString:@"Scene"]) {
        NSLog(@"Touched wall.");
    } else {
        NSLog(@"Began contact (%@, %@)", nodeA.name, nodeB.name);
    }
}

#pragma mark - Helpers
+ (SKLabelNode *)newControlNode:(NSString *)text withFontColor:(SKColor *)fontColor {
    SKLabelNode *labelNode = [self newLabelNode:text withFontColor:fontColor];
    labelNode.fontName = @"AvenirNext-Bold";
    labelNode.fontSize = 32.f;
    return labelNode;
}

+ (SKLabelNode *)newLabelNode:(NSString *)text withFontColor:(SKColor *)fontColor {
    SKLabelNode *labelNode = [SKLabelNode labelNodeWithFontNamed:@"Helvetica-Neue"];
    labelNode.zPosition = 1000;
    labelNode.fontSize = 20.f;
    labelNode.fontColor = fontColor;
    labelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    labelNode.text = text;
    return labelNode;
}

#pragma mark - Kamcord 
- (void)startRecording {
#ifdef KAMCORD_ENABLED
    [Kamcord startRecording];
#endif
}

- (void)stopRecording {
#ifdef KAMCORD_ENABLED
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [Kamcord stopRecording];
        [Kamcord showView];
    });
#endif
}

@end
