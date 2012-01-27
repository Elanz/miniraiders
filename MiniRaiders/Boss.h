//
//  Boss.h
//  MiniRaiders
//
//  Created by elanz on 1/26/12.
//  Copyright (c) 2012 200Monkeys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class MainGameController;

@interface Boss : NSObject {
    CCSprite * _bossSprite;
    CCSpriteBatchNode * _bossSpriteBatch;
    MainGameController * _gameController;
}

@property (nonatomic, readwrite) float totalHealth;
@property (nonatomic, readwrite) float currentHealth;
@property (nonatomic, readwrite) float damageDone;

- (id) initWithGameController:(MainGameController*)controller;

@end
