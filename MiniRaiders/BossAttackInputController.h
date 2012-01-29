//
//  BossAttackInputController.h
//  MiniRaiders
//
//  Created by elanz on 1/27/12.
//  Copyright (c) 2012 200Monkeys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class BossAttackController;
@class Entity;

@interface BossAttackInputController : NSObject <CCStandardTouchDelegate> {
    BossAttackController * _bossAttackController;
    NSMutableArray * _entityList;
    Entity * _entityBeingTracked;
}

- (id)initWithBossAttackController:(BossAttackController*)controller;

@end
