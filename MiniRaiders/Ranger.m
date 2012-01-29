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
        self.XP = 0;
        self.Level = 0;
        self.meleeRange = 15;
        self.range = 150;
        self.dmgLow = 15;
        self.dmgHigh = 20;
        _timeSinceLastAttack = 0;
        self.pixelsPerSecond = 30.0;
    }
    return self;
}

@end
