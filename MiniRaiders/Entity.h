//
//  Entity.h
//  MiniRaiders
//
//  Created by elanz on 1/27/12.
//  Copyright (c) 2012 200Monkeys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#define entity_idle 0
#define entity_melee 1
#define entity_walk 2
#define entity_range 3
#define entity_hurt 4
#define entity_death 5
#define entity_dead 6

@class BossAttackController;

@interface Entity : CCSprite {
    BossAttackController * _parentController;
    
    CCAnimate * _walk;
    CCAnimate * _idle;
    CCAnimate * _melee;
    CCAnimate * _range;
    CCAnimate * _hurt;
    CCAnimate * _death;
    
    CCAction * _currentMoveAction;
    CCAction * _currentAnimation;
    
    CCProgressTimer * _entityHealthBar;
    
    CCNode * _entityGroup;
    
    int _state;
    int _newState;
    double _timeSinceLastAttack;
    
    NSString * _namePrefix;
    Entity * _target;
    CGPoint _goal;
    double _totalHealth;
    double _currentHealth;
    double _damageDone;
    double _healingDone;
    double _attackCooldown;
    double _pixelsPerSecond;
    double _meleeRange;
    double _spellRange;
    double _dmgLow;
    double _dmgHigh;
    double _healLow;
    double _healHigh;
}

@property (nonatomic, readwrite) double totalHealth;
@property (nonatomic, readwrite) double currentHealth;
@property (nonatomic, readwrite) double damageDone;
@property (nonatomic, readwrite) double healingDone;
@property (nonatomic, readwrite) double attackCooldown;
@property (nonatomic, readwrite) double pixelsPerSecond;
@property (nonatomic, readwrite) double meleeRange;
@property (nonatomic, readwrite) double spellRange;
@property (nonatomic, readwrite) double dmgLow;
@property (nonatomic, readwrite) double dmgHigh;
@property (nonatomic, readwrite) double healLow;
@property (nonatomic, readwrite) double healHigh;
@property (nonatomic, retain) NSString * namePrefix;
@property (nonatomic, retain) BossAttackController * parentController;
@property (nonatomic, readwrite) CGPoint goal;
@property (nonatomic, retain) Entity * target;
@property (nonatomic, retain) NSNumber * entityId;
@property (nonatomic, readwrite) int newState;

- (id) initWithNamePrefix:(NSString*)prefix;
- (void) AITick:(ccTime)dt;
- (void) AnimationComplete;
- (void) movementComplete;
- (void) cancelMovement;
- (void) chooseTarget;
- (void) attackTarget;
- (void) takeDamage:(double)dmg from:(Entity*)entity;
- (void) heal:(double)dmg from:(Entity*)entity;
- (double) rangeToTarget:(Entity*)entity;

@end
