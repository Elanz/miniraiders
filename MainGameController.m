//
//  MainGameController.m
//  MiniRaiders
//
//  Created by elanz on 1/27/12.
//  Copyright (c) 2012 200Monkeys. All rights reserved.
//

#import "MainGameController.h"
#import "Guild.h"

#import "Warrior.h"
#import "Ranger.h"
#import "Wizard.h"

@implementation MainGameController

@synthesize theGuild = _theGuild;

- (void) loadGame
{
    _theGuild = [[Guild alloc] init];
    [_theGuild.Heroes addObject:[[Warrior alloc] init]];
    [_theGuild.Heroes addObject:[[Ranger alloc] init]];
    [_theGuild.Heroes addObject:[[Wizard alloc] init]];
}

- (void) saveGame
{
    
}

@end
