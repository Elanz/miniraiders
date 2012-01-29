//
//  MiniRaidersDelegate.h
//  MiniRaiders
//
//  Created by elanz on 1/24/12.
//  Copyright 200Monkeys 2012. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

@class MainGameController;

@interface MiniRaidersDelegate : NSObject <UIApplicationDelegate, CCDirectorDelegate>
{
	UIWindow * _window;
	UINavigationController * _navController;

	CCDirectorIOS * _director;							// weak ref
    
    MainGameController * _gameController;
}

@property (nonatomic, retain) UIWindow *window;
@property (readonly) UINavigationController *navController;
@property (readonly) CCDirectorIOS *director;
@property (nonatomic, retain) MainGameController * gameController;

+ (MiniRaidersDelegate *) sharedAppDelegate;

@end
