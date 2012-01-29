//
//  Wizard.m
//  MiniRaiders
//
//  Created by elanz on 1/27/12.
//  Copyright (c) 2012 200Monkeys. All rights reserved.
//

#import "Wizard.h"
#import "Guild.h"
#import "BossAttackController.h"
#import "Boss.h"

@implementation Wizard

- (id) init
{
    if ((self = [super initWithNamePrefix:@"wiz"]))
    {
        self.totalHealth = 80;
        self.currentHealth = 80;
        self.attackCooldown = 1.5;
        self.XP = 0;
        self.Level = 0;
        self.meleeRange = 15;
        self.range = 150;
        self.dmgLow = 5;
        self.dmgHigh = 10;
        self.healLow = 15;
        self.healHigh = 20;
        _timeSinceLastAttack = 0;
        self.pixelsPerSecond = 25.0;
    }
    return self;
}

- (void) chooseTarget
{
    Entity * newTarget;
    for (Entity * hero in [Guild sharedGuild].Heroes)
    {
        if (hero.currentHealth > 0 && hero.currentHealth < hero.totalHealth && [self rangeToTarget:hero] < self.range)
        {
            newTarget = hero;
            break;
        }
    }
    
    if (newTarget) self.target = newTarget;
    else self.target = _parentController.theBoss;
}

- (void) attackTarget
{
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
        self.healingDone += healing;
        NSLog(@"healing %@ for %lf", self.target.namePrefix, healing);
    }
}

@end
