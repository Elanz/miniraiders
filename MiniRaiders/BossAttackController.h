//
//  BossAttackController.h
//  MiniRaiders
//
//  Created by elanz on 1/26/12.
//  Copyright (c) 2012 200Monkeys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class MainGameController;
@class BackgroundLayer;
@class GameplayLayer;
@class GameHudLayer;
@class Boss;
@class BossAttackInputController;

@interface BossAttackController : CCNode {
    BackgroundLayer * _backgroundLayer;
    GameplayLayer * _gameplayLayer;
    GameHudLayer * _hudLayer;
    CCScene * _bossAttackScene;
    Boss * _theBoss;
    BossAttackInputController * _inputController;
}

@property (nonatomic, retain) BackgroundLayer * backgroundLayer;
@property (nonatomic, retain) GameplayLayer * gameplayLayer;
@property (nonatomic, retain) GameHudLayer * hudLayer;
@property (nonatomic, retain) Boss * theBoss;
@property (nonatomic, retain) NSDate * gameStartTime; 
@property (nonatomic, retain) CCSpriteBatchNode * spriteBatch;
@property (nonatomic, retain) MainGameController * gameController;

- (CCScene *) scene;
- (void) doWin;
- (void) start;
- (void) AITick:(ccTime)dt;
- (void) attackBoss:(double)dmg;

@end
