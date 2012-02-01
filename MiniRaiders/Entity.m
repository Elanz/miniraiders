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

@implementation Entity

@synthesize totalHealth = _totalHealth;
@synthesize currentHealth = _currentHealth;
@synthesize damageDone = _damageDone;
@synthesize healingDone = _healingDone;
@synthesize attackCooldown = _attackCooldown;
@synthesize namePrefix = _namePrefix;
@synthesize fullName = _fullName;
@synthesize parentController = _parentController;
@synthesize goal = _goal;
@synthesize pixelsPerSecond = _pixelsPerSecond;
@synthesize target = _target;
@synthesize spellRange = _spellRange;
@synthesize meleeRange = _meleeRange;
@synthesize dmgLow = _dmgLow;
@synthesize dmgHigh = _dmgHigh;
@synthesize healLow = _healLow;
@synthesize healHigh = _healHigh;
@synthesize entityId = _entityId;
@synthesize newState = _newState;
@synthesize defense = _defense;

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
    _death = [CCAnimate actionWithAnimation:[Cocos2dUtility createAnimationWithName:[self appendNamePrefix:@"%@_dead"] andFrameCount:2]];
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    [_parentController.spriteBatch addChild:self];
    _newState = entity_idle;
    [self runAction:[self callBackAction:_idle]];
    
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
        _angle = 90;
        _newState = entity_idle;
        _currentMoveAction = nil;
    }
}

- (void) setGoal:(CGPoint)newGoal
{
    if (self.currentHealth <= 0)
        return;
    
    _oldgoal = _goal;
    _goal = newGoal;
    
    if (!CGPointEqualToPoint(self.position, _goal))
    {
        _newState = entity_walk;
        double distance = [Cocos2dUtility distanceBetweenPointsA:self.position B:_goal];
        double duration = distance / self.pixelsPerSecond;
        if (_currentMoveAction) [self stopAction:_currentMoveAction];
        [_entityHealthBar stopAllActions];
        _currentMoveAction = [Cocos2dUtility callBackActionWithAction:[CCMoveTo actionWithDuration:duration position:_goal] target:self sel:@selector(movementComplete)];
        [self runAction:_currentMoveAction];

        CGPoint firstVector = ccpSub(_oldgoal, self.position);
        CGFloat firstRotateAngle = -ccpToAngle(firstVector);
        CGFloat previousTouch = CC_RADIANS_TO_DEGREES(firstRotateAngle);
        
        CGPoint vector = ccpSub(_goal, self.position);
        CGFloat rotateAngle = -ccpToAngle(vector);
        CGFloat currentTouch = CC_RADIANS_TO_DEGREES(rotateAngle);
        
        _angle += currentTouch - previousTouch;
        _angle = fmod(_angle,360.0);
        
        [self runAction:[CCRotateTo actionWithDuration:0.2 angle:_angle]];
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
    if( (self=[super initWithSpriteFrameName:[NSString stringWithFormat:@"%@_dead2.png", prefix]])) {
        self.namePrefix = prefix;
        _goal = CGPointZero;
        _angle = 90;
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
        case entity_death:
            _state = entity_death;
            _newState = entity_dead;
            _currentAnimation = [self callBackAction:_death];
            break;
        case entity_dead:
            _state = entity_dead;
            _currentAnimation = nil;
            break;
        case entity_idle:
        default:
            _state = entity_idle;
            _currentAnimation = [self callBackAction:_idle];
            break;
    }
    
    if (_currentAnimation)
        [self runAction:_currentAnimation];
}

- (double) rangeToTarget:(Entity*)entity
{
    double distance = [Cocos2dUtility distanceBetweenPointsA:self.position B:entity.position];
    double entityRadius = fmin(entity.boundingBox.size.width, entity.boundingBox.size.height)/2;
    return distance - entityRadius;
}

- (void) takeDamage:(double)dmg from:(Entity*)entity
{
    self.currentHealth -= dmg;    
    if (self.currentHealth <= 0) 
    {
        self.currentHealth = 0;
        self.goal = self.position;
        [self cancelMovement];
    }
    _entityHealthBar.percentage = (self.currentHealth/self.totalHealth)*100;
}

- (void) heal:(double)dmg from:(Entity*)entity
{
    self.currentHealth += dmg;
    if (self.currentHealth > self.totalHealth) self.currentHealth = self.totalHealth;
    
    _entityHealthBar.percentage = (self.currentHealth/self.totalHealth)*100;    
}

- (void) attackTarget
{
    if ([self rangeToTarget:self.target] < self.meleeRange)
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
    if (self.currentHealth <= 0)
        return;
    
    _timeSinceLastAttack += dt;
    if (_timeSinceLastAttack > self.attackCooldown)
    {
        [self chooseTarget];
        
        if (self.target && [self rangeToTarget:self.target] < self.spellRange)
            [self attackTarget];
            
        _timeSinceLastAttack = 0;
    }
}

@end
