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

- (void) prepareForBossAttack:(BossAttackController *)controller
{
    _bossAttackController = controller;
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    int startY = 40;
    int startX = 40;
    int howMany = [Heroes count] - 1;
    int width = winSize.width - 80;
    float deltaX = (float)width / (float)howMany;
    
    for (Hero * hero in Heroes)
    {
        [hero setParentBatch:controller.spriteBatch];
        [hero.entitySprite setPosition:ccp(startX, startY)];
        startX += deltaX;
    }
}

@end