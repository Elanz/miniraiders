//
//  Boss.h
//  MiniRaiders
//
//  Created by elanz on 1/26/12.
//  Copyright (c) 2012 200Monkeys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class MainGameController;

@interface Boss : NSObject {
    CCSprite * _bossSprite;
    CCSpriteBatchNode * _bossSpriteBatch;
    MainGameController * _gameController;
    
    CCAnimate * _walk;
    CCAnimate * _idle;
    CCAnimate * _melee;
    CCAnimate * _range;
    CCAnimate * _hurt;
    CCAction * _currentAction;
    
    int _state;
    int _newState;
    double _timeSinceLastAttack;
}

@property (nonatomic, readwrite) float totalHealth;
@property (nonatomic, readwrite) float currentHealth;
@property (nonatomic, readwrite) float damageDone;
@property (nonatomic, readwrite) double attackCooldown;

- (id) initWithGameController:(MainGameController*)controller;
- (void) AITick:(ccTime)dt;
- (void) AnimationComplete;

@end
