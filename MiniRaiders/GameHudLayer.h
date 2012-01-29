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
@class Entity;

@interface GameHudLayer : CCLayer {
    CCLabelTTF * _timeLabel;
    CCLabelTTF * _DPSLabel;
    CCSprite * _scorePanel;
    CCSprite * _overlay;
    CCSprite * _bottomPanel;
    Entity * _bottomPanelEntity;
}

@property (nonatomic, assign) BossAttackController * bossAttackController;
@property (nonatomic, retain) Entity * bottomPanelEntity;

- (id) initWithGameController:(BossAttackController*)controller;
- (void) showOverlay:(NSString*)filename;
- (void) hideOverlay;
- (void) showBottomPanelForEntity:(Entity*)entity;
- (void) hideBottomPanel;
- (void) bottomPanelTouchLeft;
- (void) bottomPanelTouchRight;

@end
