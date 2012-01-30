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
@synthesize className = _className;
@synthesize attackOn = _attackOn;
@synthesize abilityBtnSprite = _abilityBtnSprite;
@synthesize abilityCooldown = _abilityCooldown;
@synthesize timeSinceLastAbilityUse = _timeSinceLastAbilityUse;

- (void) setParentController:(BossAttackController *)parent
{
    [super setParentController:parent];
 
    _abilityBtnSprite = [CCSprite spriteWithSpriteFrameName:[self appendNamePrefix:@"%@_specialbtn.png"]];
    [_abilityBtnSprite setAnchorPoint:ccp(0,1)];
    [_parentController.spriteBatch addChild:_abilityBtnSprite];
    [_abilityBtnSprite setVisible:NO];
}

- (void) chooseTarget
{
    self.target = _parentController.theBoss;
}

- (void) attackTarget
{
    if (!_attackOn)
        return;
    
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

- (void) AITick:(ccTime)dt
{
    [super AITick:dt];
    
    self.timeSinceLastAbilityUse += dt;
}

- (void) performSpecialAbility
{
    self.timeSinceLastAbilityUse = 0;
}

@end
