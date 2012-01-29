//
//  Cocos2dUtility.h.h
//  MiniRaiders
//
//  Created by elanz on 1/27/12.
//  Copyright (c) 2012 200Monkeys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Cocos2dUtility : NSObject

+ (CCAnimation*) createAnimationWithName:(NSString*)name andFrameCount:(int)frameCount;
+ (CCAction*) callBackActionWithAction:(CCFiniteTimeAction*)action target:(id)target sel:(SEL)sel;
+ (float) distanceBetweenPointsA:(CGPoint)a B:(CGPoint)b;

@end
