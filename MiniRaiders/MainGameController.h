//
//  MainGameController.h
//  MiniRaiders
//
//  Created by elanz on 1/26/12.
//  Copyright (c) 2012 200Monkeys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class BackgroundLayer;
@class GameplayLayer;
@class GameHudLayer;
@class Boss;

@interface MainGameController : NSObject {
    BackgroundLayer * _backgroundLayer;
    GameplayLayer * _gameplayLayer;
    GameHudLayer * _hudLayer;
    CCScene * _mainGameScene;
    Boss * _theBoss;
}

@property (nonatomic, retain) BackgroundLayer * backgroundLayer;
@property (nonatomic, retain) GameplayLayer * gameplayLayer;
@property (nonatomic, retain) GameHudLayer * hudLayer;
@property (nonatomic, retain) Boss * theBoss;
@property (nonatomic, retain) NSDate * gameStartTime; 

- (CCScene *) scene;
- (void) doWin;
- (void) start;

@end
