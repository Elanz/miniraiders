//
//  GameHudLayer.h
//  MiniRaiders
//
//  Created by elanz on 1/26/12.
//  Copyright (c) 2012 200Monkeys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class MainGameController;

@interface GameHudLayer : CCLayer {
    CCLabelTTF * _timeLabel;
    CCLabelTTF * _DPSLabel;
    CCSprite * _scorePanel;
    CCProgressTimer * _bossHealth;
}

@property (nonatomic, assign) MainGameController * gameController;

- (id) initWithGameController:(MainGameController*)controller;

@end
