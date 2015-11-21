//
//  TimerUtils.h
//  CLCycleScrollView
//
//  Created by L on 15-11-22.
//  Copyright (c) 2015年 L. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Expand)

- (void)pauseTimer;
- (void)resumeTimer;
- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval;

@end
