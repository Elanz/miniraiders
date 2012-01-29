//
//  GameHudLayer.m
//  MiniRaiders
//
//  Created by elanz on 1/26/12.
//  Copyright (c) 2012 200Monkeys. All rights reserved.
//

#import "GameHudLayer.h"
#import "BossAttackController.h"
#import "Boss.h"
#import "Guild.h"

@implementation GameHudLayer

@synthesize bossAttackController = _bossAttackController;
@synthesize bottomPanelEntity = _bottomPanelEntity;

-(id) initWithGameController:(BossAttackController*)controller
{
	if( (self=[super init])) {
        self.bossAttackController = controller;
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        _scorePanel = [CCSprite spriteWithFile:@"top_score_panel.png"];
        [_scorePanel setPosition:ccp(winSize.width/2,winSize.height-10)];
        [self addChild:_scorePanel];
        
        _bottomPanel = [CCSprite spriteWithFile:@"bottom_panel.png"];
        [self addChild:_bottomPanel];
        [_bottomPanel setPosition:ccp(0, 0-_bottomPanel.boundingBox.size.height)];
        
        _timeLabel = [CCLabelTTF labelWithString:@"00:00" fontName:@"Courier New" fontSize:16];
        [_timeLabel setColor:ccBLACK];
        [_timeLabel setPosition:ccp(285,winSize.height-11)];
        [self addChild:_timeLabel];
        
        _DPSLabel = [CCLabelTTF labelWithString:@"000000000000" fontName:@"Courier New" fontSize:16];
        [_DPSLabel setColor:ccBLACK];
        [_DPSLabel setPosition:ccp(120,winSize.height-11)];
        [self addChild:_DPSLabel];
        
        [self scheduleUpdate];
	}
	return self;
}

- (void) showOverlay:(NSString*)filename
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    _overlay = [CCSprite spriteWithFile:filename];
    [_overlay setPosition:ccp(winSize.width/2,winSize.height/2)];
    [self addChild:_overlay];
}

- (void) hideOverlay
{
    [self removeChild:_overlay cleanup:YES];
}

- (NSString*) stringFromInterval:(NSTimeInterval)interval
{
    int minute = floor(interval/60);
    int second = round(interval - minute * 60);
    NSString * result = [NSString stringWithFormat:@"%02d:%02d",minute, second];
    return result;
}

- (void) update:(ccTime)dt
{
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:self.bossAttackController.gameStartTime];
    [_timeLabel setString:[self stringFromInterval:interval]];
    [_DPSLabel setString:[NSString stringWithFormat:@"%012d", (int)([[Guild sharedGuild] damageDone]/interval)]];
}

- (void) showBottomPanelForEntity:(Entity*)entity
{
    if (!_bottomPanelEntity)
    {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        [_bottomPanel setPosition:ccp(winSize.width/2, 0-(_bottomPanel.boundingBox.size.height/2))];
        CGPoint destination = ccp(winSize.width/2, (_bottomPanel.boundingBox.size.height/2));
        [_bottomPanel runAction:[CCMoveTo actionWithDuration:0.3 position:destination]];
        _bottomPanelEntity = entity;
    }
}

- (void) hideBottomPanel
{
    if (_bottomPanelEntity)
    {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        _bottomPanelEntity = nil;
        CGPoint destination = ccp(winSize.width/2, 0-(_bottomPanel.boundingBox.size.height/2));
        [_bottomPanel runAction:[CCMoveTo actionWithDuration:0.3 position:destination]];
    }
}

- (void) bottomPanelTouchLeft
{
    
}

- (void) bottomPanelTouchRight
{
    
}

@end
