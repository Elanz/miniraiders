//
//  Hero.h
//  MiniRaiders
//
//  Created by elanz on 1/27/12.
//  Copyright (c) 2012 200Monkeys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entity.h"

@interface Hero : Entity

@property (nonatomic, readwrite) int XP;
@property (nonatomic, readwrite) int Level;

@end
