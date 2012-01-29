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
#import "Boss.h"

#define entity_idle 0
#define entity_melee 1
#define entity_walk 2
#define entity_range 3
#define entity_hurt 4

@implementation Entity

@synthesize totalHealth;
@synthesize currentHealth;
@synthesize damageDone;
@synthesize attackCooldown;
@synthesize namePrefix;
@synthesize parentController = _parentController;
@synthesize goal = _goal;
@synthesize pixelsPerSecond;
@synthesize target;
@synthesize range;
@synthesize meleeRange;
@synthesize dmgLow;
@synthesize dmgHigh;

- (NSString*) appendNamePrefix:(NSString*)source
{
    return [NSString stringWithFormat:source, self.namePrefix];
}

- (CCAction*) callBackAction:(CCFiniteTimeAction*)action
{
    return [Cocos2dUtility callBackActionWithAction:action target:self sel:@selector(AnimationComplete)];
}

- (void) adjustHealthBarPosition
{
    CGPoint myPos = self.position;
    myPos.y += (self.boundingBox.size.height/2) + 10;
    _entityHealthBar.midpoint = ccp(0,myPos.y);
    _entityHealthBar.position = myPos;
    _entityHealthBar.percentage = (self.currentHealth/self.totalHealth)*100;
}

- (void) setParentController:(BossAttackController *)parent
{
    _parentController = parent;
    
    _walk = [CCAnimate actionWithAnimation:[Cocos2dUtility createAnimationWithName:[self appendNamePrefix:@"%@_walk"] andFrameCount:2]];
    _idle = [CCAnimate actionWithAnimation:[Cocos2dUtility createAnimationWithName:[self appendNamePrefix:@"%@_idle"] andFrameCount:2]];
    _melee = [CCAnimate actionWithAnimation:[Cocos2dUtility createAnimationWithName:[self appendNamePrefix:@"%@_melee"] andFrameCount:2]];
    _range = [CCAnimate actionWithAnimation:[Cocos2dUtility createAnimationWithName:[self appendNamePrefix:@"%@_range"] andFrameCount:2]];
    _hurt = [CCAnimate actionWithAnimation:[Cocos2dUtility createAnimationWithName:[self appendNamePrefix:@"%@_hurt"] andFrameCount:2]];
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    [_parentController.spriteBatch addChild:self];
    _state = entity_idle;
    [self runAction:[self callBackAction:_idle]];
    [self setPosition:ccp(winSize.width/2,winSize.height-120)];
    
    _entityHealthBar = [CCProgressTimer progressWithSprite:[CCSprite spriteWithSpriteFrameName:[self appendNamePrefix:@"%@_healthbar.png"]]];
    _entityHealthBar.type = kCCProgressTimerTypeBar;
    _entityHealthBar.midpoint = ccp(0,winSize.height-30);
    _entityHealthBar.barChangeRate = ccp(1,0);
    [_parentController.gameplayLayer addChild:_entityHealthBar];
    [self adjustHealthBarPosition];
}

- (void) movementComplete
{
    if (CGPointEqualToPoint(_goal, self.position))
    {
        _newState = entity_idle;
        _currentMoveAction = nil;
    }
}

- (void) setGoal:(CGPoint)newGoal
{
    if (!CGPointEqualToPoint(_goal, newGoal))
    {
        _goal = newGoal;
        _newState = entity_walk;
        float distance = [Cocos2dUtility distanceBetweenPointsA:self.position B:_goal];
        float duration = distance / self.pixelsPerSecond;
        if (_currentMoveAction) [self stopAction:_currentMoveAction];
        [_entityHealthBar stopAllActions];
        _currentMoveAction = [Cocos2dUtility callBackActionWithAction:[CCMoveTo actionWithDuration:duration position:_goal] target:self sel:@selector(movementComplete)];
        [self runAction:_currentMoveAction];
    }
}

- (void) cancelMovement
{
    _goal = self.position;
    [self stopAction:_currentMoveAction];
    [self movementComplete];
}

- (void) setPosition:(CGPoint)newPos
{
    [super setPosition:newPos];
    [self adjustHealthBarPosition];
}

- (id) initWithNamePrefix:(NSString*)prefix
{
    if( (self=[super initWithSpriteFrameName:[NSString stringWithFormat:@"%@_idle1.png", prefix]])) {
        self.namePrefix = prefix;
        _goal = CGPointZero;
    }
    return self;
}

- (void) AnimationComplete
{
    int oldState = _state;
    
    switch (_newState) {
        case entity_melee:
            _state = entity_melee;
            _newState = oldState;
            _currentAnimation = [self callBackAction:_melee];
            break;
        case entity_walk:
            _state = entity_walk;
            _currentAnimation = [self callBackAction:_walk];
            break;
        case entity_range:
            _state = entity_range;
            _newState = oldState;
            _currentAnimation = [self callBackAction:_range];
            break;
        case entity_hurt:
            _state = entity_hurt;
            _newState = oldState;
            _currentAnimation = [self callBackAction:_hurt];
            break;
        case entity_idle:
        default:
            _state = entity_idle;
            _currentAnimation = [self callBackAction:_idle];
            break;
    }
    
    [self runAction:_currentAnimation];
}

- (float) rangeToTarget
{
    float distanceToBoss = [Cocos2dUtility distanceBetweenPointsA:self.position B:self.target.position];
    float bossRadius = (self.target.boundingBox.size.width + self.target.boundingBox.size.height)/2;
    return distanceToBoss - bossRadius;
}

- (void) takeDamage:(float)dmg
{
    self.currentHealth -= dmg;
    _newState = entity_hurt;
    [self stopAction:_currentAnimation];
    [self AnimationComplete];
    
    _entityHealthBar.percentage = (self.currentHealth/self.totalHealth)*100;
}

- (void) attackTarget
{
    if ([self rangeToTarget] < self.meleeRange)
    {
        _newState = entity_melee;
    }
    else
    {
        _newState = entity_range;
    }
}

- (void) chooseTarget {};

- (void) AITick:(ccTime)dt
{
    _timeSinceLastAttack += dt;
    if (_timeSinceLastAttack > self.attackCooldown)
    {
        if (!self.target)
            [self chooseTarget];
        
        if (self.target && [self rangeToTarget] < self.range)
            [self attackTarget];
            
        _timeSinceLastAttack = 0;
    }
}

@end
