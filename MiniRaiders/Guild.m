//
//  Guild.m
//  MiniRaiders
//
//  Created by elanz on 1/27/12.
//  Copyright (c) 2012 200Monkeys. All rights reserved.
//

#import "Guild.h"
#import "Hero.h"
#import "BossAttackController.h"
#import "MiniRaidersDelegate.h"
#import "MainGameController.h"

@implementation Guild

@synthesize Name;
@synthesize Heroes;
@synthesize Fame;

+ (Guild*) sharedGuild
{
    return [MiniRaidersDelegate sharedAppDelegate].gameController.theGuild;
}

- (id) init
{
    if ((self=[super init]))
    {
        self.Name = @"Demo Guild";
        self.Heroes = [NSMutableArray array];
        self.Fame = 0;
    }
    return self;
}

- (double) damageDone
{
    double totalDamage = 0;
    for (Hero * hero in Heroes)
    {
        totalDamage += hero.damageDone;
    }
    return totalDamage;
}

- (void) prepareForBossAttack:(BossAttackController *)controller
{
    _bossAttackController = controller;
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    int startY = 40;
    int startX = 40;
    int howMany = [Heroes count] - 1;
    int width = winSize.width - 80;
    double deltaX = (double)width / (double)howMany;
    
    for (Hero * hero in Heroes)
    {
        hero.damageDone = 0;
        hero.currentHealth = hero.totalHealth;
        hero.newState = entity_idle;
        [hero setParentController:controller];
        [hero setPosition:ccp(startX, startY)];
        [hero setGoal:ccp(startX, startY)];
        startX += deltaX;
    }
}

- (Hero*) getHeroById:(NSNumber *)Id
{
    for (Hero * entity in self.Heroes)
    {
        if ([entity.entityId compare:Id] == NSOrderedSame)
        {
            return entity;
        }
    }
    
    return nil;
}

- (void) AITick:(ccTime)dt
{
    for (Hero * hero in Heroes)
    {
        [hero AITick:dt];
    }
}

@end
