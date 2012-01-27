//
//  BossAttackController.m
//  MiniRaiders
//
//  Created by elanz on 1/26/12.
//  Copyright (c) 2012 200Monkeys. All rights reserved.
//

#import "BossAttackController.h"
#import "BackgroundLayer.h"
#import "GameplayLayer.h"
#import "GameHudLayer.h"
#import "MainMenuLayer.h"
#import "Boss.h"
#import "Guild.h"

@implementation BossAttackController

@synthesize gameController;
@synthesize backgroundLayer = _backgroundLayer;
@synthesize gameplayLayer = _gameplayLayer;
@synthesize hudLayer = _hudLayer;
@synthesize theBoss = _theBoss;
@synthesize gameStartTime;
@synthesize spriteBatch;

-(CCScene *) scene
{
	_bossAttackScene = [CCScene node];
    _backgroundLayer = [[BackgroundLayer alloc] init];
    _gameplayLayer = [[GameplayLayer alloc] init];
    _hudLayer = [[GameHudLayer alloc] initWithGameController:self];
    
    [_backgroundLayer setZOrder:-1];
    [_gameplayLayer setZOrder:0];
    [_hudLayer setZOrder:1];
    
    [_bossAttackScene addChild:_backgroundLayer];
    [_bossAttackScene addChild:_gameplayLayer];
    [_bossAttackScene addChild:_hudLayer];
    [_bossAttackScene addChild:self];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"sprites.plist"];
    self.spriteBatch = [CCSpriteBatchNode batchNodeWithFile:@"sprites.png"];
    [self.gameplayLayer addChild:self.spriteBatch];
    
    _theBoss = [[Boss alloc] init];
    
    [self start];
	return _bossAttackScene;
}

- (void) start
{
    [_theBoss setParentBatch:self.spriteBatch];
    [[Guild sharedGuild] prepareForBossAttack:self];
    
    self.gameStartTime = [NSDate date];
    [self schedule:@selector(AITick:) interval:0.5f];
}

- (void) doWin
{
    [[CCDirector sharedDirector] replaceScene: [MainMenuLayer scene]]; 
}

- (void) AITick:(ccTime)dt
{
    [_theBoss AITick:dt];
}

@end