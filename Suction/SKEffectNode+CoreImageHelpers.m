//
//  SKEffectNode+CoreImageHelpers.m
//  Suction
//
//  Created by Sam Green on 8/4/14.
//  Copyright (c) 2014 Sam Green. All rights reserved.
//

#import "SKEffectNode+CoreImageHelpers.h"

@implementation SKEffectNode (CoreImageHelpers)

+ (instancetype)nodeWithFilterNamed:(NSString *)filterName andInputRadius:(CGFloat)inputRadius {
    SKEffectNode *effectNode = [self nodeWithFilterNamed:filterName];
    [effectNode.filter setValue:@(inputRadius) forKey:@"inputRadius"];
    return effectNode;
}

+ (instancetype)nodeWithFilterNamed:(NSString *)filterName {
    SKEffectNode *effectNode = [[self alloc] init];
    [effectNode setFilter:[CIFilter filterWithName:filterName]];
    [effectNode.filter setDefaults];
    return effectNode;
}

@end
