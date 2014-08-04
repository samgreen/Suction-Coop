//
//  ViewController.m
//  Suction
//
//  Created by Sam Green on 7/31/14.
//  Copyright (c) 2014 Sam Green. All rights reserved.
//

#import "GameViewController.h"
#import "LevelScene.h"
#import <Kamcord/Kamcord.h>

static NSString *const kKamcordDeveloperKey     = @"";
static NSString *const kKamcordDeveloperSecret  = @"";

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupKamcord];

    // Configure the view.
    SKView *skView = (SKView *)self.view;
#ifdef DEBUG
//    skView.showsFPS = YES;
//    skView.showsNodeCount = YES;
//    if ([skView respondsToSelector:@selector(showsPhysics)]) {
//        skView.showsPhysics = YES;
//    }
#endif
    
    // Create and configure the scene.
    LevelScene *scene = [LevelScene sceneWithSize:CGSizeMake(1024, 768)];
    scene.level = 2;
    
    // Present the scene.
    [skView presentScene:scene];
}

- (void)setupKamcord {
#ifdef KAMCORD_ENABLED
    // Initialize Kamcord
    [Kamcord setDeveloperKey:kKamcordDeveloperKey
             developerSecret:kKamcordDeveloperSecret
                     appName:@"Suction"
        parentViewController:self];
#endif
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
