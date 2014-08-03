//
//  SKNode+SKNode_ArchiveHelpers.m
//  Suction
//
//  Created by Sam Green on 8/3/14.
//  Copyright (c) 2014 Sam Green. All rights reserved.
//

#import "SKNode+ArchiveHelpers.h"

@implementation SKNode (ArchiveHelpers)

+ (id)loadArchive:(NSString *)name {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:name ofType:@"sks"]];
}

@end
