//
//  ViewController.m
//  Suction
//
//  Created by Sam Green on 7/31/14.
//  Copyright (c) 2014 Sam Green. All rights reserved.
//

#import "ViewController.h"
#import "LevelScene.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Configure the view.
    SKView *skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
//    skView.showsPhysics = YES;
    
    // Create and configure the scene.
    LevelScene *scene = [LevelScene sceneWithSize:CGSizeMake(1024, 768)];
    scene.level = 3;
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

@end
