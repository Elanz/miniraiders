//
//  Entity.h
//  MiniRaiders
//
//  Created by elanz on 1/27/12.
//  Copyright (c) 2012 200Monkeys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class BossAttackController;

@interface Entity : NSObject {
    CCSprite * _entitySprite;
    CCSpriteBatchNode * _parentBatch;
    
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
@property (nonatomic, retain) NSString * namePrefix;
@property (nonatomic, retain) CCSprite * entitySprite;
@property (nonatomic, retain) CCSpriteBatchNode * parentBatch;

- (id) initWithNamePrefix:(NSString*)prefix;
- (void) AITick:(ccTime)dt;
- (void) AnimationComplete;

@end
