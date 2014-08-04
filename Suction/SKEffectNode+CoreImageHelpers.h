//
//  SKEffectNode+CoreImageHelpers.h
//  Suction
//
//  Created by Sam Green on 8/4/14.
//  Copyright (c) 2014 Sam Green. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SKEffectNode (CoreImageHelpers)

+ (instancetype)nodeWithFilterNamed:(NSString *)filterName;
+ (instancetype)nodeWithFilterNamed:(NSString *)filterName andInputRadius:(CGFloat)inputRadius;

@end
