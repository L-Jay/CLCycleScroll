//
//  TimerUtils.m
//  CLCycleScrollView
//
//  Created by L on 15-11-22.
//  Copyright (c) 2015年 L. All rights reserved.
//

#import "TimerUtils.h"

@implementation NSTimer (Expand)

-(void)pauseTimer
{
    if ([self isValid])
        [self setFireDate:[NSDate distantFuture]];
}

-(void)resumeTimer
{
    if ([self isValid])
        [self setFireDate:[NSDate date]];
}

- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval
{
    if ([self isValid])
        [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
}

@end

