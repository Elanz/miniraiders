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

@implementation GameHudLayer

@synthesize bossAttackController;

-(id) initWithGameController:(BossAttackController*)controller
{
	if( (self=[super init])) {
        self.bossAttackController = controller;
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        _scorePanel = [CCSprite spriteWithFile:@"top_score_panel.png"];
        [_scorePanel setPosition:ccp(winSize.width/2,winSize.height-20)];
        [self addChild:_scorePanel];
        
        _timeLabel = [CCLabelTTF labelWithString:@"00:00" fontName:@"Courier New" fontSize:16];
        [_timeLabel setColor:ccBLACK];
        [_timeLabel setPosition:ccp(285,winSize.height-11)];
        [self addChild:_timeLabel];
        
        _DPSLabel = [CCLabelTTF labelWithString:@"000000000000" fontName:@"Courier New" fontSize:16];
        [_DPSLabel setColor:ccBLACK];
        [_DPSLabel setPosition:ccp(120,winSize.height-11)];
        [self addChild:_DPSLabel];
        
        _bossHealth = [CCProgressTimer progressWithSprite:[CCSprite spriteWithFile:@"bosshealth.png"]];
        _bossHealth.type = kCCProgressTimerTypeBar;
        _bossHealth.midpoint = ccp(0,winSize.height-30);
        _bossHealth.barChangeRate = ccp(1,0);
        _bossHealth.position = ccp((winSize.width/2),winSize.height-31);
        [self addChild:_bossHealth];
        
        [self scheduleUpdate];
	}
	return self;
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
    [_DPSLabel setString:[NSString stringWithFormat:@"%012d", (int)(self.bossAttackController.theBoss.damageDone/interval)]];
    _bossHealth.percentage = (self.bossAttackController.theBoss.currentHealth/self.bossAttackController.theBoss.totalHealth)*100;
}

@end
