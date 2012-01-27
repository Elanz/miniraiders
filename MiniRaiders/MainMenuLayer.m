//
//  MainMenuLayer.m
//  MiniRaiders
//
//  Created by elanz on 1/24/12.
//  Copyright 200Monkeys 2012. All rights reserved.
//

#import "MainMenuLayer.h"
#import "AppDelegate.h"
#import "MainGameController.h"

#pragma mark - MainMenuLayer

@implementation MainMenuLayer

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	MainMenuLayer *layer = [MainMenuLayer node];
	[scene addChild: layer];
	return scene;
}

-(id) init
{
	if( (self=[super init])) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CCSprite * backgroundTexture = [CCSprite spriteWithFile:@"mainmenu_bg.png"];
        [backgroundTexture setPosition:ccp(winSize.width/2,winSize.height/2)];
        [self addChild:backgroundTexture];
        CCMenuItem * startBtn = [CCMenuItemImage itemWithNormalImage:@"start_btn_up.png" selectedImage:@"start_btn_down.png" target:self selector:@selector(startGame)];
        CCMenu * mainMenu = [CCMenu menuWithItems:startBtn, nil];
        [mainMenu alignItemsVertically];
        [self addChild:mainMenu];
	}
	return self;
}

-(void)startGame
{
    gameController = [[MainGameController alloc] init];
    [[CCDirector sharedDirector] replaceScene:[gameController scene]];
}

@end
