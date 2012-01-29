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

@interface Entity : CCSprite {
    BossAttackController * _parentController;
    
    CCAnimate * _walk;
    CCAnimate * _idle;
    CCAnimate * _melee;
    CCAnimate * _range;
    CCAnimate * _hurt;
    
    CCAction * _currentMoveAction;
    CCAction * _currentAnimation;
    
    CCProgressTimer * _entityHealthBar;
    
    CCNode * _entityGroup;
    
    int _state;
    int _newState;
    float _timeSinceLastAttack;
    
    CGPoint _goal;
}

@property (nonatomic, readwrite) float totalHealth;
@property (nonatomic, readwrite) float currentHealth;
@property (nonatomic, readwrite) float damageDone;
@property (nonatomic, readwrite) float attackCooldown;
@property (nonatomic, readwrite) float pixelsPerSecond;
@property (nonatomic, readwrite) float meleeRange;
@property (nonatomic, readwrite) float range;
@property (nonatomic, readwrite) float dmgLow;
@property (nonatomic, readwrite) float dmgHigh;
@property (nonatomic, retain) NSString * namePrefix;
@property (nonatomic, retain) BossAttackController * parentController;
@property (nonatomic, readwrite) CGPoint goal;
@property (nonatomic, retain) Entity * target;

- (id) initWithNamePrefix:(NSString*)prefix;
- (void) AITick:(ccTime)dt;
- (void) AnimationComplete;
- (void) cancelMovement;
- (void) chooseTarget;
- (void) attackTarget;
- (void) takeDamage:(float)dmg;

@end
