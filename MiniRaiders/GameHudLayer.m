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
#import "Hero.h"
#import "Guild.h"

@implementation GameHudLayer

@synthesize bossAttackController = _bossAttackController;
@synthesize bottomPanelEntity = _bottomPanelEntity;

- (CCLabelTTF*) labelWithSize:(CGPoint)size alignment:(UITextAlignment)alignment
{
    return [CCLabelTTF labelWithString:@"" dimensions:CGSizeMake(size.x,size.y) alignment:alignment fontName:@"HelveticaNeue-Bold" fontSize:14];
}

-(id) initWithGameController:(BossAttackController*)controller
{
	if( (self=[super init])) {
        self.bossAttackController = controller;
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        _scorePanel = [CCSprite spriteWithFile:@"top_score_panel.png"];
        [_scorePanel setPosition:ccp(winSize.width/2,winSize.height-10)];
        [self addChild:_scorePanel];
        
        _timeLabel = [CCLabelTTF labelWithString:@"00:00" fontName:@"Courier New" fontSize:16];
        [_timeLabel setColor:ccBLACK];
        [_timeLabel setPosition:ccp(285,winSize.height-11)];
        [self addChild:_timeLabel];
        
        _DPSLabel = [CCLabelTTF labelWithString:@"000000000000" fontName:@"Courier New" fontSize:16];
        [_DPSLabel setColor:ccBLACK];
        [_DPSLabel setPosition:ccp(120,winSize.height-11)];
        [self addChild:_DPSLabel];

        //bottom panel
        _bottomPanel = [CCSprite spriteWithFile:@"bottom_panel.png"];
        [self addChild:_bottomPanel];
        [_bottomPanel setPosition:ccp(0, 0-_bottomPanel.boundingBox.size.height)];
        
        _attackOn = [CCSprite spriteWithFile:@"atkon_btn.png"];
        [_attackOn setAnchorPoint:ccp(0,1)];
        [_attackOn setPosition:ccp(0,50)];
        [_bottomPanel addChild:_attackOn];
        _attackOff = [CCSprite spriteWithFile:@"atkoff_btn.png"];
        [_attackOff setAnchorPoint:ccp(0,1)];
        [_attackOff setPosition:ccp(0,50)];
        [_bottomPanel addChild:_attackOff];
        
        [_attackOn setVisible:YES];
        [_attackOff setVisible:NO];
        
        _bottomPanelLeftLabel = [self labelWithSize:ccp(50,16) alignment:UITextAlignmentLeft];
        [_bottomPanelLeftLabel setColor:ccBLACK];
        [_bottomPanelLeftLabel setAnchorPoint:ccp(0,1)];
        [_bottomPanelLeftLabel setPosition:ccp(0,16)];
        [_bottomPanel addChild:_bottomPanelLeftLabel z:1];
        
        _bottomPanelRightLabel = [self labelWithSize:ccp(50,16) alignment:UITextAlignmentRight];
        [_bottomPanelRightLabel setColor:ccBLACK];
        [_bottomPanelRightLabel setAnchorPoint:ccp(0,1)];
        [_bottomPanelRightLabel setPosition:ccp(270,16)];
        [_bottomPanel addChild:_bottomPanelRightLabel z:1];
        
        //53,3,216,16
        _bottomPanelHeaderLabel = [self labelWithSize:ccp(216,16) alignment:UITextAlignmentCenter];
        [_bottomPanelHeaderLabel setColor:ccBLACK];
        [_bottomPanelHeaderLabel setAnchorPoint:ccp(0,1)];
        [_bottomPanelHeaderLabel setPosition:ccp(53,49)];
        [_bottomPanel addChild:_bottomPanelHeaderLabel];
        
        //53,22,108,14
        _bottomPanelAtkLabel = [self labelWithSize:ccp(108,14) alignment:UITextAlignmentLeft];
        [_bottomPanelAtkLabel setColor:ccBLACK];
        [_bottomPanelAtkLabel setAnchorPoint:ccp(0,1)];
        [_bottomPanelAtkLabel setPosition:ccp(53,30)];
        [_bottomPanel addChild:_bottomPanelAtkLabel];
        
        //161,22,108,14
        _bottomPanelDefLabel = [self labelWithSize:ccp(108,14) alignment:UITextAlignmentLeft];
        [_bottomPanelDefLabel setColor:ccBLACK];
        [_bottomPanelDefLabel setAnchorPoint:ccp(0,1)];
        [_bottomPanelDefLabel setPosition:ccp(161,30)];
        [_bottomPanel addChild:_bottomPanelDefLabel];
        
        //53,36,108,14
        _bottomPanelHealLabel = [self labelWithSize:ccp(108,14) alignment:UITextAlignmentLeft];
        [_bottomPanelHealLabel setColor:ccBLACK];
        [_bottomPanelHealLabel setAnchorPoint:ccp(0,1)];
        [_bottomPanelHealLabel setPosition:ccp(53,16)];
        [_bottomPanel addChild:_bottomPanelHealLabel];
        
        //161,36,108,14
        _bottomPanelHPLabel = [self labelWithSize:ccp(108,14) alignment:UITextAlignmentLeft];
        [_bottomPanelHPLabel setColor:ccBLACK];
        [_bottomPanelHPLabel setAnchorPoint:ccp(0,1)];
        [_bottomPanelHPLabel setPosition:ccp(161,16)];
        [_bottomPanel addChild:_bottomPanelHPLabel];


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

- (void) updateBottomPanel
{
    if (!_bottomPanelEntity)
        return;
    
    if ([_bottomPanelEntity isKindOfClass:[Boss class]])
    {
        Boss * boss = (Boss*)_bottomPanelEntity;
        
        [_bottomPanelHeaderLabel setString:[NSString stringWithFormat:@"%@", boss.fullName]];
        [_attackOff setVisible:NO];
        [_attackOn setVisible:NO];
        
        double cooldown = boss.ability1Cooldown - boss.timeSinceLastAbility1Use;
        if (cooldown < 0) cooldown = 0;
        [_bottomPanelLeftLabel setString:[NSString stringWithFormat:@"%02.0f",cooldown]];
        double cooldownPercent = cooldown/boss.ability1Cooldown;
        int opacity = (1.0 - cooldownPercent) * 255.0;
        if (opacity > 255) opacity = 255;
        
        [boss.ability1BtnSprite setOpacity:opacity];
        
        [boss.ability1BtnSprite setPosition:ccp(0,50)];
        [boss.ability1BtnSprite setVisible:YES];
        
        cooldown = boss.ability2Cooldown - boss.timeSinceLastAbility2Use;
        if (cooldown < 0) cooldown = 0;
        [_bottomPanelRightLabel setString:[NSString stringWithFormat:@"%02.0f",cooldown]];
        cooldownPercent = cooldown/boss.ability2Cooldown;
        opacity = (1.0 - cooldownPercent) * 255.0;
        if (opacity > 255) opacity = 255;
        
        [boss.ability2BtnSprite setOpacity:opacity];
        
        [boss.ability2BtnSprite setPosition:ccp(270,50)];
        [boss.ability2BtnSprite setVisible:YES];
    }
    else 
    {
        Hero * hero = (Hero*)_bottomPanelEntity;
        [_bottomPanelHeaderLabel setString:[NSString stringWithFormat:@"%@ : Lvl %d %@", hero.fullName, hero.level, hero.className]];
        if (hero.attackOn)
        {
            [_attackOn setVisible:YES];
            [_attackOff setVisible:NO];
        }
        else
        {
            [_attackOn setVisible:NO];
            [_attackOff setVisible:YES];
        }
        double cooldown = hero.abilityCooldown - hero.timeSinceLastAbilityUse;
        if (cooldown < 0) cooldown = 0;
        [_bottomPanelRightLabel setString:[NSString stringWithFormat:@"%02.0f",cooldown]];
        double cooldownPercent = cooldown/hero.abilityCooldown;
        int opacity = (1.0 - cooldownPercent) * 255.0;
        if (opacity > 255) opacity = 255;
        
        [hero.abilityBtnSprite setOpacity:opacity];
        
        [hero.abilityBtnSprite setPosition:ccp(270,50)];
        [hero.abilityBtnSprite setVisible:YES];
    }
    
    [_bottomPanelDefLabel setString:[NSString stringWithFormat:@"DEF: %.1f", _bottomPanelEntity.defense]];
    double dps = ((_bottomPanelEntity.dmgLow + _bottomPanelEntity.dmgHigh) / 2) / _bottomPanelEntity.attackCooldown;
    double hps = ((_bottomPanelEntity.healLow + _bottomPanelEntity.healHigh) / 2) / _bottomPanelEntity.attackCooldown;
    [_bottomPanelAtkLabel setString:[NSString stringWithFormat:@"DPS: %.1f", dps]];
    [_bottomPanelHealLabel setString:[NSString stringWithFormat:@"HPS: %.1f", hps]];
    [_bottomPanelHPLabel setString:[NSString stringWithFormat:@"HP: %d/%d", (int)_bottomPanelEntity.currentHealth, (int)_bottomPanelEntity.totalHealth]];
}

- (void) update:(ccTime)dt
{
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:self.bossAttackController.gameStartTime];
    [_timeLabel setString:[self stringFromInterval:interval]];
    [_DPSLabel setString:[NSString stringWithFormat:@"%012d", (int)([[Guild sharedGuild] damageDone]/interval)]];
    [self updateBottomPanel];
}

- (void) clearBottomEntity
{
    if ([_bottomPanelEntity isKindOfClass:[Boss class]])
    {
        Boss * boss = (Boss*)_bottomPanelEntity;
        [boss.ability1BtnSprite setVisible:NO];
        [boss.ability2BtnSprite setVisible:NO];
    }
    else 
    {
        Hero * hero = (Hero*)_bottomPanelEntity;
        [hero.abilityBtnSprite setVisible:NO];
    }
    [_bottomPanelRightLabel setString:@""];
    [_bottomPanelLeftLabel setString:@""];
    _bottomPanelEntity = nil;
}

- (void) showBottomPanelForEntity:(Entity*)entity
{
    if (!_bottomPanelEntity)
    {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        [_bottomPanel setPosition:ccp(winSize.width/2, 0-(_bottomPanel.boundingBox.size.height/2))];
        CGPoint destination = ccp(winSize.width/2, (_bottomPanel.boundingBox.size.height/2));
        [_bottomPanel runAction:[CCMoveTo actionWithDuration:0.2 position:destination]];
        [self clearBottomEntity];
        _bottomPanelEntity = entity;
    }
    else 
    {
        [self clearBottomEntity];
        _bottomPanelEntity = entity;
        [self updateBottomPanel];
    }
}

- (void) hideBottomPanel
{
    if (_bottomPanelEntity && ![[CCDirector sharedDirector] isPaused])
    {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        [self clearBottomEntity];
        CGPoint destination = ccp(winSize.width/2, 0-(_bottomPanel.boundingBox.size.height/2));
        [_bottomPanel runAction:[CCMoveTo actionWithDuration:0.2 position:destination]];
    }
}

- (void) handleTap:(CGPoint)location
{
    if (!_bottomPanelEntity) return;
    
    if (CGRectContainsPoint(_bottomPanel.boundingBox, location))
    {
        if (location.x < 50)
        {
            if ([_bottomPanelEntity isKindOfClass:[Hero class]])
            {
                Hero * hero = (Hero*)_bottomPanelEntity;
                hero.attackOn = !hero.attackOn;
            }
        }
        else if (location.x > 270)
        {
            if ([_bottomPanelEntity isKindOfClass:[Hero class]])
            {
                Hero * hero = (Hero*)_bottomPanelEntity;
                double cooldown = hero.abilityCooldown - hero.timeSinceLastAbilityUse;
                if (cooldown < 0) 
                    [hero performSpecialAbility];
            }
        }
        else 
        {
            if ([[CCDirector sharedDirector] isPaused]) [[CCDirector sharedDirector] resume];
            else [[CCDirector sharedDirector] pause];
        }
        [self updateBottomPanel];
    }
    else 
        [self hideBottomPanel];
}

@end
