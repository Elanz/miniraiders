//
//  BossAttackInputController.m
//  MiniRaiders
//
//  Created by elanz on 1/27/12.
//  Copyright (c) 2012 200Monkeys. All rights reserved.
//

#import "BossAttackInputController.h"
#import "BossAttackController.h"
#import "GameHudLayer.h"
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
    for (Entity * hero in [Guild sharedGuild].Heroes)
    {
        [_entityList addObject:hero];
    }
    [_entityList addObject:_bossAttackController.theBoss];
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"touch began");
    [self rebuildEntityList];
    UITouch * touch = [touches anyObject];
    CGPoint loc = [_bossAttackController convertTouchToNodeSpace:touch];
    BOOL entitySelected = NO;
    for (Entity * entity in _entityList)
    {
        if (CGRectContainsPoint(entity.boundingBox, loc))
        {
            entitySelected = YES;
            [_bossAttackController.hudLayer showBottomPanelForEntity:entity];
            if ([entity isKindOfClass:[Hero class]])
            {
                _entityBeingTracked = entity;
            }
            break;
        }
    }
    if (!entitySelected)
    {
        [_bossAttackController.hudLayer handleTap:loc];
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
    
    if (CGRectContainsPoint(_entityBeingTracked.boundingBox, loc))
    {
        [_entityBeingTracked cancelMovement];
    }
    
    _entityBeingTracked = nil;
}

- (void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"touch cancel");
    _entityBeingTracked = nil;
}


@end
