//
//  Boss.m
//  MiniRaiders
//
//  Created by elanz on 1/26/12.
//  Copyright (c) 2012 200Monkeys. All rights reserved.
//

#import "Boss.h"
#import "MainGameController.h"
#import "Cocos2dUtility.h"
#import "GameplayLayer.h"

#define bossState_idle 0
#define bossState_melee 1

@implementation Boss

@synthesize totalHealth;
@synthesize currentHealth;
@synthesize damageDone;
@synthesize attackCooldown;

- (CCAction*) callBackAction:(CCFiniteTimeAction*)action
{
    return [Cocos2dUtility callBackActionWithAction:action target:self sel:@selector(AnimationComplete)];
}

- (id) initWithGameController:(MainGameController*)controller
{
    if( (self=[super init])) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        _gameController = controller;
        
        self.totalHealth = 1000;
        self.currentHealth = 1000;
        self.attackCooldown = 1.5;
        _timeSinceLastAttack = 0;
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"boss1.plist"];
        _bossSpriteBatch = [CCSpriteBatchNode batchNodeWithFile:@"boss1.png"];
        _bossSprite = [CCSprite spriteWithSpriteFrameName:@"boss_idle1.png"];
        [_bossSpriteBatch addChild:_bossSprite];
        [_gameController.gameplayLayer addChild:_bossSpriteBatch];
        
        _walk = [CCAnimate actionWithAnimation:[Cocos2dUtility createAnimationWithName:@"boss_walk" andFrameCount:2]];
        _idle = [CCAnimate actionWithAnimation:[Cocos2dUtility createAnimationWithName:@"boss_idle" andFrameCount:2]];
        _melee = [CCAnimate actionWithAnimation:[Cocos2dUtility createAnimationWithName:@"boss_attack" andFrameCount:2]];
        _range = [CCAnimate actionWithAnimation:[Cocos2dUtility createAnimationWithName:@"boss_range" andFrameCount:2]];
        _hurt = [CCAnimate actionWithAnimation:[Cocos2dUtility createAnimationWithName:@"boss_hurt" andFrameCount:2]];
        
        _state = bossState_idle;
        [_bossSprite runAction:[self callBackAction:_idle]];
        
        [_bossSprite setPosition:ccp(winSize.width/2,winSize.height-120)];
    }
    return self;
}
                                
- (void) AnimationComplete
{
    switch (_newState) {
        case bossState_melee:
            _state = bossState_melee;
            _newState = bossState_idle;
            [_bossSprite runAction:[self callBackAction:_melee]];
            break;
        case bossState_idle:
        default:
            _state = bossState_idle;
            [_bossSprite runAction:[self callBackAction:_idle]];
            break;
    }
}

- (void) AITick:(ccTime)dt
{
    _timeSinceLastAttack += dt;
    if (_timeSinceLastAttack > self.attackCooldown)
    {
        // try attack
    }
}

@end
