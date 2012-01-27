//
//  Boss.m
//  MiniRaiders
//
//  Created by elanz on 1/26/12.
//  Copyright (c) 2012 200Monkeys. All rights reserved.
//

#import "Boss.h"
#import "MainGameController.h"

@implementation Boss

@synthesize totalHealth;
@synthesize currentHealth;
@synthesize damageDone;

- (id) initWithGameController:(MainGameController*)controller
{
    if( (self=[super init])) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        _gameController = controller;
        
        self.totalHealth = 1000;
        self.currentHealth = 1000;
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"boss1.plist"];
        _bossSpriteBatch = [CCSpriteBatchNode batchNodeWithFile:@"boss1.png"];
        _bossSprite = [CCSprite spriteWithSpriteFrameName:@"boss_idle1.png"];
        [_bossSpriteBatch addChild:_bossSprite];
        [_gameController.gameplayLayer addChild:_bossSpriteBatch];
        
        [_bossSprite setPosition:ccp(winSize.width/2,winSize.height-120)];
    }
    return self;
}

@end
