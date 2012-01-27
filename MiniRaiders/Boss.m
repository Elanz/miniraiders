//
//  Boss.m
//  MiniRaiders
//
//  Created by elanz on 1/26/12.
//  Copyright (c) 2012 200Monkeys. All rights reserved.
//

#import "Boss.h"

@implementation Boss

- (id) init
{
    if ((self = [super initWithNamePrefix:@"boss1"]))
    {
        self.totalHealth = 1000;
        self.currentHealth = 1000;
        self.attackCooldown = 1.5;
        _timeSinceLastAttack = 0;
    }
    return self;
}

@end
