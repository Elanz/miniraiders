//
//  BackgroundLayer.m
//  MiniRaiders
//
//  Created by elanz on 1/26/12.
//  Copyright (c) 2012 200Monkeys. All rights reserved.
//

#import "BackgroundLayer.h"

@implementation BackgroundLayer

-(id) init
{
	if( (self=[super init])) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CCSprite * backgroundTexture = [CCSprite spriteWithFile:@"proto_field.png"];
        [backgroundTexture setPosition:ccp(winSize.width/2,winSize.height/2)];
        [self addChild:backgroundTexture];
	}
	return self;
}

@end
