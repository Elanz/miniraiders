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

@implementation Boss

- (id) init
{
    if ((self = [super initWithNamePrefix:@"boss1"]))
    {
        self.totalHealth = 1000;
        self.currentHealth = 1000;
        self.attackCooldown = 1.5;
        _timeSinceLastAttack = 0;        
        self.meleeRange = 120;
        self.spellRange = 200;
        self.dmgLow = 5;
        self.dmgHigh = 10;
        self.pixelsPerSecond = 10;
        _threatTable = [NSMutableDictionary dictionary];
        _patrolPoints = [NSMutableArray array];
    }
    return self;
}

- (void) setParentController:(BossAttackController *)parent
{
    [super setParentController:parent];
    
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

- (void) movementComplete
{
    [super movementComplete];
    
    if (!self.target)
        [self walkToNextPatrolPoint];
}

- (void) walkToNextPatrolPoint
{
    _currentPatrolPoint ++;
    if (_currentPatrolPoint == [_patrolPoints count])
        _currentPatrolPoint = 0;
    
    CGPoint newGoal = [[_patrolPoints objectAtIndex:_currentPatrolPoint] CGPointValue];
    self.goal = newGoal;
}

- (void) AITick:(ccTime)dt
{
    [super AITick:dt];
    
    if (self.target)
    {
        CGPoint newGoal = self.target.position;
        double targetHeight = self.target.boundingBox.size.height;
        double myHeight = self.boundingBox.size.height;
        if (self.target.boundingBox.origin.y > self.boundingBox.origin.y)
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
