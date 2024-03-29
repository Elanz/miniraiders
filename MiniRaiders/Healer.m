//
//  Healer.m
//  MiniRaiders
//
//  Created by elanz on 1/27/12.
//  Copyright (c) 2012 200Monkeys. All rights reserved.
//

#import "Healer.h"
#import "Guild.h"
#import "BossAttackController.h"
#import "Boss.h"

@implementation Healer

- (id) init
{
    if ((self = [super initWithNamePrefix:@"wiz"]))
    {
        self.totalHealth = 80;
        self.currentHealth = 80;
        self.attackCooldown = 1.8;
        self.xp = 0;
        self.level = 1;
        self.meleeRange = 15;
        self.spellRange = 150;
        self.dmgLow = 5;
        self.dmgHigh = 10;
        self.healLow = 15;
        self.healHigh = 20;
        self.threatFactor = 0.9;
        _timeSinceLastAttack = 0;
        self.abilityCooldown = 10.0;
        self.timeSinceLastAbilityUse = 0;
        self.pixelsPerSecond = 25.0;
        self.defense = 1;
        self.attackOn = NO;
        self.className = @"Healer";
    }
    return self;
}

- (void) chooseTarget
{
    Entity * newTarget;
    for (Entity * hero in [Guild sharedGuild].Heroes)
    {
        if (hero.currentHealth > 0 && hero.currentHealth < hero.totalHealth && [self rangeToTarget:hero] < self.spellRange)
        {
            newTarget = hero;
            break;
        }
    }
    
    if (newTarget) {
        double targetHPPercent = ((newTarget.currentHealth/newTarget.totalHealth) * 100);
        if (targetHPPercent < 60)
            self.target = newTarget;
        else self.target = _parentController.theBoss;
    }
    else self.target = _parentController.theBoss;
}

- (void) attackTarget
{
    if (!self.attackOn)
        return;
    
    _newState = entity_range;
    if ([self.target isKindOfClass:[Boss class]])
    {
        double damage = self.dmgLow + fmod(arc4random(), self.dmgHigh);
        [_parentController attackBoss:damage from:self];
        self.damageDone += damage;
    }
    else 
    {
        double healing = self.healLow + fmod(arc4random(), self.healHigh);
        [self.target heal:healing from:self];
        [_parentController observeHealing:healing from:self];
        self.healingDone += healing;
    }
}

@end
