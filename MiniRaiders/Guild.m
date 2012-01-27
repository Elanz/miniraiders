//
//  Guild.m
//  MiniRaiders
//
//  Created by elanz on 1/27/12.
//  Copyright (c) 2012 200Monkeys. All rights reserved.
//

#import "Guild.h"

@implementation Guild

@synthesize Name;
@synthesize Heroes;
@synthesize Fame;

- (id) init
{
    if ((self=[super init]))
    {
        self.Name = @"Demo Guild";
        self.Heroes = [NSMutableArray array];
        self.Fame = 0;
    }
    return self;
}

@end
