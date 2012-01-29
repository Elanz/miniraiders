//
//  MainGameController.m
//  MiniRaiders
//
//  Created by elanz on 1/27/12.
//  Copyright (c) 2012 200Monkeys. All rights reserved.
//

#import "MainGameController.h"
#import "Guild.h"

#import "Entity.h"
#import "Warrior.h"
#import "Ranger.h"
#import "Wizard.h"

@implementation MainGameController

@synthesize theGuild = _theGuild;

- (void) loadGame
{
    _theGuild = [[Guild alloc] init];
    Entity * hero1 = [[Warrior alloc] init];
    Entity * hero2 = [[Ranger alloc] init];
    Entity * hero3 = [[Wizard alloc] init];
    hero1.EntityId = [NSNumber numberWithInt:1];
    hero2.EntityId = [NSNumber numberWithInt:2];
    hero3.EntityId = [NSNumber numberWithInt:3];
    [_theGuild.Heroes addObject:hero1];
    [_theGuild.Heroes addObject:hero2];
    [_theGuild.Heroes addObject:hero3];
}

- (void) saveGame
{
    
}

@end
