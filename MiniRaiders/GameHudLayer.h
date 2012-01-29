//
//  GameHudLayer.h
//  MiniRaiders
//
//  Created by elanz on 1/26/12.
//  Copyright (c) 2012 200Monkeys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class BossAttackController;

@interface GameHudLayer : CCLayer {
    CCLabelTTF * _timeLabel;
    CCLabelTTF * _DPSLabel;
    CCSprite * _scorePanel;
}

@property (nonatomic, assign) BossAttackController * bossAttackController;

- (id) initWithGameController:(BossAttackController*)controller;

@end
