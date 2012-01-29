//
//  BossAttackInputController.m
//  MiniRaiders
//
//  Created by elanz on 1/27/12.
//  Copyright (c) 2012 200Monkeys. All rights reserved.
//

#import "BossAttackInputController.h"
#import "BossAttackController.h"
#import "Entity.h"
#import "Hero.h"
#import "Boss.h"
#import "Guild.h"

@implementation BossAttackInputController

- (id)initWithBossAttackController:(BossAttackController*)controller
{
    if ((self = [super init]))
    {
        _bossAttackController = controller;
        [[CCDirector sharedDirector].touchDispatcher addStandardDelegate:self priority:1]; 
        _entityList = [NSMutableArray array];
    }
    return self;
}

- (void)rebuildEntityList
{
    [_entityList removeAllObjects];
    [_entityList addObject:_bossAttackController.theBoss];
    for (Entity * hero in [Guild sharedGuild].Heroes)
    {
        [_entityList addObject:hero];
    }
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"touch began");
    [self rebuildEntityList];
    UITouch * touch = [touches anyObject];
    CGPoint loc = [_bossAttackController convertTouchToNodeSpace:touch];
    for (Entity * entity in _entityList)
    {
        if ([entity isKindOfClass:[Hero class]] && CGRectContainsPoint(entity.boundingBox, loc))
        {
            _entityBeingTracked = entity;
            break;
        }
    }
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"touch move");
    UITouch * touch = [touches anyObject];
    CGPoint loc = [_bossAttackController convertTouchToNodeSpace:touch];
    if (_entityBeingTracked)
        [_entityBeingTracked setGoal:loc];
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"touch end");
    UITouch * touch = [touches anyObject];
    CGPoint loc = [_bossAttackController convertTouchToNodeSpace:touch];
    for (Entity * entity in _entityList)
    {
        if ([entity isKindOfClass:[Boss class]] && CGRectContainsPoint(entity.boundingBox, loc))
        {
            _entityBeingTracked.target = entity;
            //[_entityBeingTracked cancelMovement];
            break;
        }
    }
    _entityBeingTracked = nil;
}

- (void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"touch cancel");
    _entityBeingTracked = nil;
}


@end
