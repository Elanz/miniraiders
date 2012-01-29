//
//  BossAttackController.m
//  MiniRaiders
//
//  Created by elanz on 1/26/12.
//  Copyright (c) 2012 200Monkeys. All rights reserved.
//

#import "BossAttackController.h"
#import "BossAttackInputController.h"
#import "BackgroundLayer.h"
#import "GameplayLayer.h"
#import "GameHudLayer.h"
#import "MainMenuLayer.h"
#import "Boss.h"
#import "Guild.h"
#import "Entity.h"

@implementation BossAttackController

@synthesize gameController = _gameController;
@synthesize backgroundLayer = _backgroundLayer;
@synthesize gameplayLayer = _gameplayLayer;
@synthesize hudLayer = _hudLayer;
@synthesize theBoss = _theBoss;
@synthesize gameStartTime = _gameStartTime;
@synthesize spriteBatch = _spriteBatch;

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
    
    self.spriteBatch = [CCSpriteBatchNode batchNodeWithFile:@"sprites.png"];
    [self.gameplayLayer addChild:self.spriteBatch];
    
    _theBoss = [[Boss alloc] init];
    
    _inputController = [[BossAttackInputController alloc] initWithBossAttackController:self];
    
	return _bossAttackScene;
}

- (void) hideOverlay
{
    [_hudLayer hideOverlay];
}

- (void) start
{
    [_theBoss setParentController:self];
    [[Guild sharedGuild] prepareForBossAttack:self];
    
    self.gameStartTime = [NSDate date];
    [self schedule:@selector(AITick:) interval:0.1f];
    [_hudLayer showOverlay:@"fight.png"];
    [self scheduleOnce:@selector(hideOverlay) delay:1.5];
}

- (void) returnToMainMenu
{
    [_hudLayer hideOverlay];
    [self.spriteBatch removeAllChildrenWithCleanup:YES];
    [self.backgroundLayer removeAllChildrenWithCleanup:YES];
    [self.hudLayer removeAllChildrenWithCleanup:YES];
    [self.gameplayLayer removeAllChildrenWithCleanup:YES];
    [[CCDirector sharedDirector] replaceScene: [MainMenuLayer scene]]; 
}

- (void) doWin
{
    [_hudLayer showOverlay:@"win.png"];
    [self scheduleOnce:@selector(returnToMainMenu) delay:1.5];
}

- (void) doLose
{
    [_hudLayer showOverlay:@"lose.png"];
    [self scheduleOnce:@selector(returnToMainMenu) delay:1.5];
}

- (void) heroDied:(Entity*)hero
{
    for (Entity * heroToTest in [Guild sharedGuild].Heroes)
    {
        if (heroToTest.currentHealth > 0)
            return;
    }
    
    [self doLose];
}

- (void) AITick:(ccTime)dt
{
    [_theBoss AITick:dt];
    [[Guild sharedGuild] AITick:dt];
}

- (void) attackBoss:(double)dmg from:(Entity*)entity
{
    [_theBoss takeDamage:dmg from:entity];
    if (_theBoss.currentHealth <= 0) [self doWin];
}

- (void) observeHealing:(double)healing from:(Entity*)entity
{
    [_theBoss observeHealing:healing fromWho:entity];
}

- (void) draw
{
    ccDrawColor4f(1.0, 0.0, 0.0, 1.0);  
    if (!CGPointEqualToPoint(_theBoss.position, _theBoss.goal))
        ccDrawLine(_theBoss.position, _theBoss.goal);
    for (Entity * hero in [Guild sharedGuild].Heroes)
    {
        if (!CGPointEqualToPoint(hero.position, hero.goal))
            ccDrawLine(hero.position, hero.goal);
    }
}

@end
