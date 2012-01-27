//
//  Cocos2dUtility.h.m
//  MiniRaiders
//
//  Created by elanz on 1/27/12.
//  Copyright (c) 2012 200Monkeys. All rights reserved.
//

#import "Cocos2dUtility.h"

@implementation Cocos2dUtility

+ (CCAnimation*) createAnimationWithName:(NSString*)name andFrameCount:(int)frameCount
{
    NSMutableArray *animFrames = [NSMutableArray array];
    for(int i = 1; i <= frameCount; i++) {
        
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"%@%d.png",name,i]];
        [animFrames addObject:frame];
    }
    CCAnimation *animation = [CCAnimation animationWithFrames:animFrames delay:0.2f];
    return animation;
}

+ (CCAction*) callBackActionWithAction:(CCFiniteTimeAction*)action target:(id)target sel:(SEL)sel
{
    return [CCSequence actions:action, [CCCallFunc actionWithTarget:target selector:sel], nil];
}

@end
