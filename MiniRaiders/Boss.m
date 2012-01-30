//
//  Boss.m
//  MiniRaiders
//
//  Created by elanz on 1/26/12.
//  Copyright (c) 2012 200Monkeys. All rights reserved.
//

#import "Boss.h"
#import "Guild.h"
#import "Hero.h"
#import "Cocos2dUtility.h"
#import "BossAttackController.h"

@implementation Boss

@synthesize ability1BtnSprite = _ability1BtnSprite;
@synthesize ability2BtnSprite = _ability2BtnSprite;
@synthesize ability1Cooldown = _ability1Cooldown;
@synthesize timeSinceLastAbility1Use = _timeSinceLastAbility1Use;
@synthesize ability2Cooldown = _ability2Cooldown;
@synthesize timeSinceLastAbility2Use = _timeSinceLastAbility2Use;

- (id) init
{
    if ((self = [super initWithNamePrefix:@"boss1"]))
    {
        self.totalHealth = 1000;
        self.currentHealth = 1000;
        self.attackCooldown = 1.5;
        _timeSinceLastAttack = 0;   
        _ability1Cooldown = 5.0;
        _ability2Cooldown = 3.0;
        _timeSinceLastAbility1Use = 0;
        _timeSinceLastAbility2Use = 0;
        self.meleeRange = 100;
        self.spellRange = 180;
        self.dmgLow = 5;
        self.dmgHigh = 10;
        self.pixelsPerSecond = 10;
        self.fullName = @"Prototype Boss";
        self.defense = 4;
        _threatTable = [NSMutableDictionary dictionary];
        _patrolPoints = [NSMutableArray array];
    }
    return self;
}

- (void) setParentController:(BossAttackController *)parent
{
    [super setParentController:parent];
    
    _ability1BtnSprite = [CCSprite spriteWithSpriteFrameName:[self appendNamePrefix:@"%@_special1btn.png"]];
    [_ability1BtnSprite setAnchorPoint:ccp(0,1)];
    [_parentController.spriteBatch addChild:_ability1BtnSprite];
    [_ability1BtnSprite setVisible:NO];
    _ability2BtnSprite = [CCSprite spriteWithSpriteFrameName:[self appendNamePrefix:@"%@_special2btn.png"]];
    [_ability2BtnSprite setAnchorPoint:ccp(0,1)];
    [_parentController.spriteBatch addChild:_ability2BtnSprite];
    [_ability2BtnSprite setVisible:NO];
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    double quarterScreenWidth = winSize.width/4;
    double halfHeight = self.boundingBox.size.height/2;
    [_patrolPoints addObject:[NSValue valueWithCGPoint:ccp(quarterScreenWidth*2,winSize.height-halfHeight*2)]];
    [_patrolPoints addObject:[NSValue valueWithCGPoint:ccp(quarterScreenWidth,winSize.height-halfHeight*3)]];
    [_patrolPoints addObject:[NSValue valueWithCGPoint:ccp(quarterScreenWidth*2,winSize.height-halfHeight*4)]];
    [_patrolPoints addObject:[NSValue valueWithCGPoint:ccp(quarterScreenWidth*3,winSize.height-halfHeight*3)]];
    _currentPatrolPoint = 0;
}

- (void) chooseTarget
{
    // try to find an in-range living target
    double highDmg = 0;
    Entity * newTarget;
    for (NSNumber * entityId in [_threatTable allKeys])
    {
        double thisDmg = [((NSNumber*)[_threatTable objectForKey:entityId]) doubleValue];
        if (thisDmg > highDmg)
        {
            Entity * possibleTarget = [[Guild sharedGuild] getHeroById:entityId];
            if (possibleTarget.currentHealth > 0 && [self rangeToTarget:possibleTarget] < self.spellRange)
            {
                highDmg = thisDmg;
                newTarget = possibleTarget;
            }
        }
    }
    
    if (newTarget) {self.target = newTarget; return;}
    
    // try to find any living target
    highDmg = 0;
    for (NSNumber * entityId in [_threatTable allKeys])
    {
        double thisDmg = [((NSNumber*)[_threatTable objectForKey:entityId]) doubleValue];
        if (thisDmg > highDmg)
        {
            Entity * possibleTarget = [[Guild sharedGuild] getHeroById:entityId];
            if (possibleTarget.currentHealth > 0)
            {
                highDmg = thisDmg;
                newTarget = possibleTarget;
            }
        }
    }
    
    self.target = newTarget;
}

- (void) debugLogThreat
{
    NSString * threatlog = @"threat = ";
    for (NSNumber * entityId in [_threatTable allKeys])
    {
        Entity * possibleTarget = [[Guild sharedGuild] getHeroById:entityId];
        double thisDmg = [((NSNumber*)[_threatTable objectForKey:entityId]) doubleValue];
        threatlog = [threatlog stringByAppendingFormat:@" %@ = %f; ", possibleTarget.namePrefix, thisDmg];
    }
    NSLog(@"%@", threatlog);
}

- (void) observeHealing:(double)healing fromWho:(Entity*)entity
{
    if ([self rangeToTarget:entity] > self.spellRange)
        return;
    
    NSNumber * threat = [_threatTable objectForKey:entity.entityId];
    if (!threat) 
    {
        threat = [NSNumber numberWithDouble:0];
    }
    double currentThreat = [threat doubleValue];
    currentThreat += (healing * ((Hero*)entity).threatFactor);
    [_threatTable setObject:[NSNumber numberWithDouble:currentThreat] forKey:entity.entityId];
    //[self debugLogThreat];
}

- (void) takeDamage:(double)dmg from:(Entity *)entity
{
    [super takeDamage:dmg from:entity];
    NSNumber * threat = [_threatTable objectForKey:entity.entityId];
    if (!threat) 
    {
        threat = [NSNumber numberWithDouble:0];
    }
    double currentThreat = [threat doubleValue];
    if ([entity isKindOfClass:[Hero class]])
    {
        currentThreat += (dmg * ((Hero*)entity).threatFactor);
    }
    else 
    {
        currentThreat += dmg;
    }
    [_threatTable setObject:[NSNumber numberWithDouble:currentThreat] forKey:entity.entityId];
    //[self debugLogThreat];
}

- (void) attackTarget
{
    [super attackTarget];
    
    double damage = self.dmgLow + fmod(arc4random(), self.dmgHigh);
    [self.target takeDamage:damage from:self];
    self.damageDone += damage;
}

- (void) walkToNextPatrolPoint
{
    _currentPatrolPoint ++;
    if (_currentPatrolPoint == [_patrolPoints count])
        _currentPatrolPoint = 0;
    
    CGPoint newGoal = [[_patrolPoints objectAtIndex:_currentPatrolPoint] CGPointValue];
    self.goal = newGoal;
}

- (void) movementComplete
{
    [super movementComplete];
    
    if (!self.target)
        [self walkToNextPatrolPoint];
}

- (void) AITick:(ccTime)dt
{
    [super AITick:dt];
    
    _timeSinceLastAbility1Use += dt;
    _timeSinceLastAbility2Use += dt;
    
    if (self.target)
    {
        CGPoint newGoal = self.target.position;
        double targetHeight = self.target.boundingBox.size.height;
        double myHeight = self.boundingBox.size.height;
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        if (self.target.boundingBox.origin.y > winSize.height - self.boundingBox.size.height)
        {
            newGoal.y -= (targetHeight/2)+(myHeight/2);
        }
        else 
        {
            newGoal.y += (targetHeight/2)+(myHeight/2);
        }
        self.goal = newGoal;
    }
    else 
    {
        if (self.newState == entity_idle)
        {
            [self walkToNextPatrolPoint];
        }
    }
}

@end
