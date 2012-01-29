//
//  Guild.h
//  MiniRaiders
//
//  Created by elanz on 1/27/12.
//  Copyright (c) 2012 200Monkeys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class BossAttackController;
@class Hero;

@interface Guild : NSObject{
    BossAttackController * _bossAttackController;
}

@property (nonatomic, retain) NSString * Name;
@property (nonatomic, retain) NSMutableArray * Heroes;
@property (nonatomic, readwrite) int Fame;
@property (nonatomic, readonly) double damageDone;

+ (Guild*) sharedGuild;

- (void) prepareForBossAttack:(BossAttackController*)controller;
- (void) AITick:(ccTime)dt;
- (Hero*) getHeroById:(NSNumber*)Id;

@end
