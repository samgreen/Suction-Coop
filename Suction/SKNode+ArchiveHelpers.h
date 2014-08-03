//
//  SKNode+SKNode_ArchiveHelpers.h
//  Suction
//
//  Created by Sam Green on 8/3/14.
//  Copyright (c) 2014 Sam Green. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SKNode (ArchiveHelpers)

+ (id)loadArchive:(NSString *)name;

@end
