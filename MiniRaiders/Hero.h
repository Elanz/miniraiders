//
//  Hero.h
//  MiniRaiders
//
//  Created by elanz on 1/27/12.
//  Copyright (c) 2012 200Monkeys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entity.h"

@interface Hero : Entity

@property (nonatomic, readwrite) int xp;
@property (nonatomic, readwrite) int level;
@property (nonatomic, readwrite) double threatFactor;
@property (nonatomic, retain) NSString * className;
@property (nonatomic, readwrite) BOOL attackOn;
@property (nonatomic, retain) CCSprite * abilityBtnSprite;
@property (nonatomic, readwrite) double abilityCooldown;
@property (nonatomic, readwrite) double timeSinceLastAbilityUse;

- (void) chooseTarget;
- (void) performSpecialAbility;

@end
