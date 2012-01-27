//
//  MainMenuLayer.h
//  MiniRaiders
//
//  Created by elanz on 1/24/12.
//  Copyright 200Monkeys 2012. All rights reserved.
//


#import <GameKit/GameKit.h>
#import "cocos2d.h"

@class BossAttackController;

@interface MainMenuLayer : CCLayer {
    BossAttackController * gameController;
}

+(CCScene *) scene;

-(void)startGame;

@end
