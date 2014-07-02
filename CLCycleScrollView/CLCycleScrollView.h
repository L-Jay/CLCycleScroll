//
//  CLCycleScrollView.h
//  CLCycleScrollView
//
//  Created by L on 14-6-27.
//  Copyright (c) 2014年 L. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CLCycleScrollViewDataSource;
@protocol CLCycleScrollViewDelegate;

@class CLCycleScrollViewContentView;

@interface CLCycleScrollView : UIView

@property (nonatomic, assign) id <CLCycleScrollViewDataSource> dataSource;
@property (nonatomic, assign) id <CLCycleScrollViewDelegate> delegate;

- (CLCycleScrollViewContentView *)dequeueReusableContentViewWithIdentifier:(NSString *)identifier;

- (void)reloadData;

- (void)nextPage;
- (void)prevPage;

@end

@protocol CLCycleScrollViewDataSource <NSObject>
@required

- (NSInteger)numberOfViewsInCycleScrollView:(CLCycleScrollView *)scrollView;

- (CLCycleScrollViewContentView *)cycleScrollView:(CLCycleScrollView *)scrollView viewAtIndex:(NSInteger)index;

@end

@protocol CLCycleScrollViewDelegate <NSObject>
@optional

- (void)cycleScrollView:(CLCycleScrollView *)scrollView willShowViewAtIndex:(NSInteger)index;

- (void)cycleScrollView:(CLCycleScrollView *)scrollView didSelectViewAtIndex:(NSInteger)index;

@end

@interface CLCycleScrollViewContentView : UIView

@property (nonatomic, copy, readonly) NSString *identifier;

- (id)initWithFrame:(CGRect)frame identifier:(NSString *)identifier;

@end
