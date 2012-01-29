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
        self.XP = 0;
        self.Level = 0;
        self.meleeRange = 20;
        self.range = 20;
        self.dmgLow = 10;
        self.dmgHigh = 15;
        _timeSinceLastAttack = 0;
        self.pixelsPerSecond = 20.0;
    }
    return self;
}

@end
