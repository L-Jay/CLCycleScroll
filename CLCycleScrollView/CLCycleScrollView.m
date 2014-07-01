//
//  CLCycleScrollView.m
//  CLCycleScrollView
//
//  Created by L on 14-6-27.
//  Copyright (c) 2014年 L. All rights reserved.
//

#import "CLCycleScrollView.h"

@interface CLCycleScrollView ()<UIScrollViewDelegate>

@property (nonatomic, retain) UIScrollView *scrollView;

@property (nonatomic, retain) NSMutableArray *contentViews;
@property (nonatomic, retain) NSMutableDictionary *reusableViewDic;

@property (nonatomic, assign) NSInteger numOfViews;

@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation CLCycleScrollView

- (void)dealloc
{
    FNRELEASE(_scrollView);
    
    FNRELEASE(_contentViews);
    FNRELEASE(_reusableViewDic);
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //===== KVO
        [self addObserver:self forKeyPath:@"currentIndex" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        
        self.contentViews = [NSMutableArray array];
        self.reusableViewDic = [NSMutableDictionary dictionary];
        
        //=====  ScrollView
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        scrollView.contentSize = CGSizeMake(self.width*3, 0);
        scrollView.backgroundColor = [UIColor orangeColor];
        scrollView.pagingEnabled = YES;
        scrollView.clipsToBounds = NO;
//        scrollView.showsVerticalScrollIndicator = NO;
//        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.delegate = self;
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        [scrollView release];
    }
    
    return self;
}

- (void)didMoveToSuperview
{
    NSInteger preViewIndex = [self validIndex:self.currentIndex-1];
    NSInteger curViewIndex = [self validIndex:self.currentIndex];
    NSInteger nexViewIndex = [self validIndex:self.currentIndex+1];
    
    CLCycleScrollViewContentView *preContentView = [self.dataSource cycleScrollView:self viewAtIndex:preViewIndex];
    CLCycleScrollViewContentView *curContentView = [self.dataSource cycleScrollView:self viewAtIndex:curViewIndex];
    CLCycleScrollViewContentView *nexContentView = [self.dataSource cycleScrollView:self viewAtIndex:nexViewIndex];
    
    [self.contentViews addObject:preContentView];
    [self.contentViews addObject:curContentView];
    [self.contentViews addObject:nexContentView];
    
    NSLog(@"%@", self.reusableViewDic);
    
    //===
    self.scrollView.contentOffset = CGPointMake(self.width, 0);
    
    //===
    [self reLayoutSubviews];
}

#pragma mark - Methods
- (void)reloadData
{
    
}

#pragma mark - Private Methods
- (NSInteger)numOfViews
{
    return [self.dataSource numberOfViewsInCycleScrollView:self];
}

- (NSInteger)validIndex:(NSInteger)index
{
    if (index == -1)
        return self.numOfViews-1;
    else if (index == self.numOfViews)
        return 0;
    else
        return index;
}

- (void)addToReusableViews:(CLCycleScrollViewContentView *)contentView
{
    NSMutableArray *array = [self.reusableViewDic objectForKey:contentView.identifier];
    if (array)
        [array addObject:contentView];
    else {
        array = [NSMutableArray arrayWithObject:contentView];
        [self.reusableViewDic setObject:array forKey:contentView.identifier];
    }
}

- (CLCycleScrollViewContentView *)dequeueReusableContentViewWithIdentifier:(NSString *)identifier
{
    NSArray *array = [self.reusableViewDic objectForKey:identifier];
    return array.count > 0 ? [array objectAtIndex:0] : nil;
}

- (void)reLayoutSubviews
{
    [self.scrollView removeAllSubviews];
    
    for (int i = 0; i < self.contentViews.count; i++) {
        UIView *view = [self.contentViews objectAtIndex:i];
        view.minX = self.width*i;
        [self.scrollView addSubview:view];
    }
}

#pragma mark - UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat willMove = round(scrollView.contentOffset.x/self.width)-1;
    
    if (willMove == 1) {
        scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x-self.width, 0);
        self.currentIndex = [self validIndex:self.currentIndex+1];
        
        [self addToReusableViews:[self.contentViews objectAtIndex:0]];
        NSLog(@"dic ----- %@", self.reusableViewDic);
        [self.contentViews removeObjectAtIndex:0];
        
        NSInteger willAddIndex = [self validIndex:self.currentIndex+1];
        NSLog(@"will ==== %d", willAddIndex);
        
        CLCycleScrollViewContentView *contentView = [self.dataSource cycleScrollView:self viewAtIndex:willAddIndex];
        [self.contentViews addObject:contentView];
        NSMutableArray *tempArray = [self.reusableViewDic objectForKey:contentView.identifier];
        [tempArray removeObject:contentView];
        
        NSLog(@"%@", self.contentViews);
        
        [self reLayoutSubviews];
        
    }else if (willMove == -1) {
        scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x+self.width, 0);
        self.currentIndex = [self validIndex:self.currentIndex-1];
        
        [self addToReusableViews:[self.contentViews lastObject]];
        NSLog(@"dic ----- %@", self.reusableViewDic);
        [self.contentViews removeObjectAtIndex:self.contentViews.count-1];
        
        NSInteger willAddIndex = [self validIndex:self.currentIndex-1];
        NSLog(@"will ==== %d", willAddIndex);
        
        CLCycleScrollViewContentView *contentView = [self.dataSource cycleScrollView:self viewAtIndex:willAddIndex];
        [self.contentViews insertObject:contentView atIndex:0];
        NSMutableArray *tempArray = [self.reusableViewDic objectForKey:contentView.identifier];
        [tempArray removeObject:contentView];
        
        NSLog(@"%@", self.contentViews);
        
        [self reLayoutSubviews];
    }
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"currentIndex"]) {
        
        //[self reloadData];
    }else if ([keyPath isEqualToString:@"contentViews"]) {
        [self reloadData];
    }
}

@end

@interface CLCycleScrollViewContentView ()

@property (nonatomic, copy) NSString *identifier;

@end

@implementation CLCycleScrollViewContentView

- (void)dealloc
{
    FNRELEASE(_identifier);
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame identifier:(NSString *)identifier
{
    if (self = [super initWithFrame:frame]) {
        self.identifier = identifier;
    }
    
    return self;
}

@end
