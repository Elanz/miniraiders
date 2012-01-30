//
//  Ranger.m
//  MiniRaiders
//
//  Created by elanz on 1/27/12.
//  Copyright (c) 2012 200Monkeys. All rights reserved.
//

#import "Ranger.h"

@implementation Ranger

- (id) init
{
    if ((self = [super initWithNamePrefix:@"rng"]))
    {
        self.totalHealth = 100;
        self.currentHealth = 100;
        self.attackCooldown = 1.5;
        self.xp = 0;
        self.level = 1;
        self.meleeRange = 15;
        self.spellRange = 150;
        self.dmgLow = 15;
        self.dmgHigh = 20;
        self.threatFactor = 1.1;
        _timeSinceLastAttack = 0;
        self.abilityCooldown = 3.0;
        self.timeSinceLastAbilityUse = 0;
        self.pixelsPerSecond = 30.0;
        self.defense = 2;
        self.attackOn = NO;
        self.className = @"Ranger";
    }
    return self;
}

@end
