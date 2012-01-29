//
//  Hero.m
//  MiniRaiders
//
//  Created by elanz on 1/27/12.
//  Copyright (c) 2012 200Monkeys. All rights reserved.
//

#import "Hero.h"
#import "Boss.h"
#import "BossAttackController.h"

@implementation Hero

@synthesize xp = _xp;
@synthesize level = _Level;
@synthesize threatFactor = _threatFactor;

- (void) chooseTarget
{
    self.target = _parentController.theBoss;
}

- (void) attackTarget
{
    [super attackTarget];
    
    double damage = self.dmgLow + fmod(arc4random(), self.dmgHigh);
    [_parentController attackBoss:damage from:self];
    self.damageDone += damage;
}

- (void) takeDamage:(double)dmg from:(Entity *)entity
{
    [super takeDamage:dmg from:entity];
    if (self.currentHealth <= 0)
    {
        _newState = entity_death;
        [_parentController heroDied:self];
    }
}

@end
