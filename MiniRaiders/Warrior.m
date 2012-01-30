//
//  Warrior.m
//  MiniRaiders
//
//  Created by elanz on 1/27/12.
//  Copyright (c) 2012 200Monkeys. All rights reserved.
//

#import "Warrior.h"

@implementation Warrior

- (id) init
{
    if ((self = [super initWithNamePrefix:@"war"]))
    {
        self.totalHealth = 120;
        self.currentHealth = 120;
        self.attackCooldown = 1.0;
        self.xp = 0;
        self.level = 1;
        self.meleeRange = 50;
        self.spellRange = 50;
        self.dmgLow = 10;
        self.dmgHigh = 15;
        self.threatFactor = 2.0;
        _timeSinceLastAttack = 0;
        self.abilityCooldown = 5.0;
        self.timeSinceLastAbilityUse = 0;
        self.pixelsPerSecond = 20.0;
        self.defense = 3;
        self.attackOn = NO;
        self.className = @"Warrior";
    }
    return self;
}

@end
