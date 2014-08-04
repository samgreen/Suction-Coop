//
//  ViewController.m
//  Suction
//
//  Created by Sam Green on 7/31/14.
//  Copyright (c) 2014 Sam Green. All rights reserved.
//

#import "ViewController.h"
#import "LevelScene.h"
#import <Kamcord/Kamcord.h>

static NSString *const kKamcordDeveloperKey     = @"";
static NSString *const kKamcordDeveloperSecret  = @"";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialize Kamcord
    [Kamcord setDeveloperKey:kKamcordDeveloperKey
             developerSecret:kKamcordDeveloperSecret
                     appName:@"Suction"
        parentViewController:self];

    // Configure the view.
    SKView *skView = (SKView *)self.view;
//    skView.showsFPS = YES;
//    skView.showsNodeCount = YES;
//    skView.showsPhysics = YES;
    
    // Create and configure the scene.
    LevelScene *scene = [LevelScene sceneWithSize:CGSizeMake(1024, 768)];
    scene.level = 1;
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
