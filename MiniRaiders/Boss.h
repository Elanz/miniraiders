//
//  Boss.h
//  MiniRaiders
//
//  Created by elanz on 1/26/12.
//  Copyright (c) 2012 200Monkeys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entity.h"

@interface Boss : Entity{
    NSMutableDictionary * _threatTable;
    NSMutableArray * _patrolPoints;
    int _currentPatrolPoint;
}

@property (nonatomic, retain) CCSprite * ability1BtnSprite;
@property (nonatomic, retain) CCSprite * ability2BtnSprite;
@property (nonatomic, readwrite) double ability1Cooldown;
@property (nonatomic, readwrite) double timeSinceLastAbility1Use;
@property (nonatomic, readwrite) double ability2Cooldown;
@property (nonatomic, readwrite) double timeSinceLastAbility2Use;

- (void) observeHealing:(double)healing fromWho:(Entity*)entity;

@end
