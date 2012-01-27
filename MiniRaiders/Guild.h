//
//  Guild.h
//  MiniRaiders
//
//  Created by elanz on 1/27/12.
//  Copyright (c) 2012 200Monkeys. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BossAttackController;

@interface Guild : NSObject{
    BossAttackController * _bossAttackController;
}

@property (nonatomic, retain) NSString * Name;
@property (nonatomic, retain) NSMutableArray * Heroes;
@property (nonatomic, readwrite) int Fame;

- (void) prepareForBossAttack:(BossAttackController*)controller;
+ (Guild*) sharedGuild;

@end
