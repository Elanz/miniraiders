//
//  Entity.m
//  MiniRaiders
//
//  Created by elanz on 1/27/12.
//  Copyright (c) 2012 200Monkeys. All rights reserved.
//

#import "Entity.h"
#import "BossAttackController.h"
#import "Cocos2dUtility.h"
#import "GameplayLayer.h"

#define entity_idle 0
#define entity_melee 1

@implementation Entity

@synthesize totalHealth;
@synthesize currentHealth;
@synthesize damageDone;
@synthesize attackCooldown;
@synthesize namePrefix;
@synthesize entitySprite = _entitySprite;
@synthesize parentBatch = _parentBatch;

- (NSString*) appendNamePrefix:(NSString*)source
{
    return [NSString stringWithFormat:source, self.namePrefix];
}

- (CCAction*) callBackAction:(CCFiniteTimeAction*)action
{
    return [Cocos2dUtility callBackActionWithAction:action target:self sel:@selector(AnimationComplete)];
}

- (void) setParentBatch:(CCSpriteBatchNode *)parent
{
    _parentBatch = parent;
    
    _walk = [CCAnimate actionWithAnimation:[Cocos2dUtility createAnimationWithName:[self appendNamePrefix:@"%@_walk"] andFrameCount:2]];
    _idle = [CCAnimate actionWithAnimation:[Cocos2dUtility createAnimationWithName:[self appendNamePrefix:@"%@_idle"] andFrameCount:2]];
    _melee = [CCAnimate actionWithAnimation:[Cocos2dUtility createAnimationWithName:[self appendNamePrefix:@"%@_melee"] andFrameCount:2]];
    _range = [CCAnimate actionWithAnimation:[Cocos2dUtility createAnimationWithName:[self appendNamePrefix:@"%@_range"] andFrameCount:2]];
    _hurt = [CCAnimate actionWithAnimation:[Cocos2dUtility createAnimationWithName:[self appendNamePrefix:@"%@_hurt"] andFrameCount:2]];
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    _entitySprite = [CCSprite spriteWithSpriteFrameName:[self appendNamePrefix:@"%@_idle1.png"]];
    [_parentBatch addChild:_entitySprite];
    _state = entity_idle;
    [_entitySprite runAction:[self callBackAction:_idle]];
    [_entitySprite setPosition:ccp(winSize.width/2,winSize.height-120)];
}

- (id) initWithNamePrefix:(NSString*)prefix
{
    if( (self=[super init])) {
        
        self.namePrefix = prefix;
    }
    return self;
}

- (void) AnimationComplete
{
    switch (_newState) {
        case entity_melee:
            _state = entity_melee;
            _newState = entity_idle;
            [_entitySprite runAction:[self callBackAction:_melee]];
            break;
        case entity_idle:
        default:
            _state = entity_idle;
            [_entitySprite runAction:[self callBackAction:_idle]];
            break;
    }
}

- (void) AITick:(ccTime)dt
{
    _timeSinceLastAttack += dt;
    if (_timeSinceLastAttack > self.attackCooldown)
    {
        // try attack
        _timeSinceLastAttack = 0;
    }
}


@end
