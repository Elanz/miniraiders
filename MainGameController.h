//
//  MainGameController.h
//  MiniRaiders
//
//  Created by elanz on 1/27/12.
//  Copyright (c) 2012 200Monkeys. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Guild;

@interface MainGameController : NSObject {
    Guild * _theGuild;
}

@property (nonatomic, retain) Guild * theGuild;

- (void) loadGame;
- (void) saveGame;

@end
