//
//  MainGameController.m
//  MiniRaiders
//
//  Created by elanz on 1/26/12.
//  Copyright (c) 2012 200Monkeys. All rights reserved.
//

#import "MainGameController.h"
#import "BackgroundLayer.h"
#import "GameplayLayer.h"
#import "GameHudLayer.h"
#import "MainMenuLayer.h"
#import "Boss.h"

@implementation MainGameController

@synthesize backgroundLayer = _backgroundLayer;
@synthesize gameplayLayer = _gameplayLayer;
@synthesize hudLayer = _hudLayer;
@synthesize theBoss = _theBoss;
@synthesize gameStartTime;

-(CCScene *) scene
{
	_mainGameScene = [CCScene node];
    _backgroundLayer = [[BackgroundLayer alloc] init];
    _gameplayLayer = [[GameplayLayer alloc] init];
    _hudLayer = [[GameHudLayer alloc] initWithGameController:self];
    
    [_backgroundLayer setZOrder:-1];
    [_gameplayLayer setZOrder:0];
    [_hudLayer setZOrder:1];
    
    [_mainGameScene addChild:_backgroundLayer];
    [_mainGameScene addChild:_gameplayLayer];
    [_mainGameScene addChild:_hudLayer];
    
    _theBoss = [[Boss alloc] initWithGameController:self];
    [self start];
	return _mainGameScene;
}

- (void) start
{
    self.gameStartTime = [NSDate date];
}

- (void) doWin
{
    [[CCDirector sharedDirector] replaceScene: [MainMenuLayer scene]]; 
}

@end
