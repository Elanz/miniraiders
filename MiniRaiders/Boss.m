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
        self.range = 200;
        self.dmgLow = 20;
        self.dmgHigh = 25;
        _threatTable = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void) chooseTarget
{
    float highDmg = 0;
    for (NSNumber * entityId in [_threatTable allKeys])
    {
        float thisDmg = [((NSNumber*)[_threatTable objectForKey:entityId]) floatValue];
        if (thisDmg > highDmg)
        {
            self.target = [[Guild sharedGuild] getHeroById:entityId];
            if (self.target.currentHealth > 0 && [self rangeToTarget] < self.range)
            {
                highDmg = thisDmg;
            }
            else 
            {
                self.target = nil;
            }
        }
    }

}

- (void) takeDamage:(float)dmg from:(Entity *)entity
{
    [super takeDamage:dmg from:entity];
    NSNumber * threat = [_threatTable objectForKey:entity.EntityId];
    if (!threat) 
    {
        threat = [NSNumber numberWithFloat:0];
    }
    float currentThreat = [threat floatValue];
    currentThreat += dmg;
    [_threatTable setObject:[NSNumber numberWithFloat:currentThreat] forKey:entity.EntityId];
}

- (void) attackTarget
{
    [super attackTarget];
    
    double damage = self.dmgLow + fmod(arc4random(), self.dmgHigh);
    [self.target takeDamage:damage from:self];
    self.damageDone += damage;
}

@end
