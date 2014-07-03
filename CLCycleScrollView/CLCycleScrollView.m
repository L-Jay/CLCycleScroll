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

@property (nonatomic, retain) UITapGestureRecognizer *tapGesture;

@property (nonatomic, retain) NSTimer *autoTimer;

@end

@implementation CLCycleScrollView

- (void)dealloc
{
    FNRELEASE(_scrollView);
    
    FNRELEASE(_contentViews);
    FNRELEASE(_reusableViewDic);
    
    FNRELEASE(_tapGesture);
    
    FNRELEASE(_autoTimer);
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.contentViews = [NSMutableArray array];
        self.reusableViewDic = [NSMutableDictionary dictionary];
        
        //=====  ScrollView
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        scrollView.tag = 1000;
        scrollView.contentSize = CGSizeMake(self.width*3, 0);
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.pagingEnabled = YES;
        scrollView.clipsToBounds = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.delegate = self;
        scrollView.contentOffset = CGPointMake(self.width, 0);
        scrollView.minimumZoomScale = 1.0;
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        [scrollView release];
        
        //===== TapGesture
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickContentView)];
        tapGesture.numberOfTapsRequired = 1;
        self.tapGesture = tapGesture;
        [tapGesture release];
    }
    
    return self;
}

- (void)didMoveToSuperview
{
    if (self.autoScrollDuration > 0) {
        //===== Timer
        self.autoTimer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollDuration
                                                          target:self
                                                        selector:@selector(nextPage)
                                                        userInfo:nil
                                                         repeats:YES];
    }
    
    [self reloadData];
}

#pragma mark - Methods
- (void)reloadData
{
    [self.contentViews removeAllObjects];
    
    NSInteger preViewIndex = [self validIndex:self.currentIndex-1];
    NSInteger curViewIndex = [self validIndex:self.currentIndex];
    NSInteger nexViewIndex = [self validIndex:self.currentIndex+1];
    
    CLCycleScrollViewContentView *preContentView = [self.dataSource cycleScrollView:self viewAtIndex:preViewIndex];
    CLCycleScrollViewContentView *curContentView = [self.dataSource cycleScrollView:self viewAtIndex:curViewIndex];
    CLCycleScrollViewContentView *nexContentView = [self.dataSource cycleScrollView:self viewAtIndex:nexViewIndex];
    
    [self.contentViews addObject:preContentView];
    [self.contentViews addObject:curContentView];
    [self.contentViews addObject:nexContentView];
    
    //===
    [self reLayoutSubviews];
}

- (void)nextPage
{
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.width*2, 0) animated:YES];
}

- (void)prevPage
{
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
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
        CLCycleScrollViewContentView *view = [self.contentViews objectAtIndex:i];
        
        //====
        if (view.zoomScale > 1.0)
            [view setZoomScale:1.0 animated:YES];
        
        //====
        view.minX = self.width*i;
        
        //====
        if (i == 1) {
            [view addGestureRecognizer:self.tapGesture];
            
            if (self.maxZoomScale > 1.0) {
                view.maximumZoomScale = self.maxZoomScale;
                [self.tapGesture requireGestureRecognizerToFail:view.doubleTapGesture];
            }
        }
        
        //====
        [self.scrollView addSubview:view];
    }
}

- (void)clickContentView
{
    [self.delegate cycleScrollView:self didSelectViewAtIndex:self.currentIndex];
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.autoTimer pauseTimer];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{    
    //=====
    CGFloat willMove = round(scrollView.contentOffset.x/self.width)-1;
    
    if (willMove == 1) {
        //====
        scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x-self.width, 0);
        self.currentIndex = [self validIndex:self.currentIndex+1];
        
        //===
        [self.delegate cycleScrollView:self willShowViewAtIndex:self.currentIndex];
        
        //===
        [self addToReusableViews:[self.contentViews objectAtIndex:0]];
        //NSLog(@"dic ----- %@", self.reusableViewDic);
        [self.contentViews removeObjectAtIndex:0];
        
        NSInteger willAddIndex = [self validIndex:self.currentIndex+1];
        
        CLCycleScrollViewContentView *contentView = [self.dataSource cycleScrollView:self viewAtIndex:willAddIndex];
        [self.contentViews addObject:contentView];
        NSMutableArray *tempArray = [self.reusableViewDic objectForKey:contentView.identifier];
        [tempArray removeObject:contentView];
        
        //===
        [self reLayoutSubviews];
        
    }else if (willMove == -1) {
        scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x+self.width, 0);
        self.currentIndex = [self validIndex:self.currentIndex-1];
        
        //===
        [self.delegate cycleScrollView:self willShowViewAtIndex:self.currentIndex];
        
        //===
        [self addToReusableViews:[self.contentViews lastObject]];
        //NSLog(@"dic ----- %@", self.reusableViewDic);
        [self.contentViews removeObjectAtIndex:self.contentViews.count-1];
        
        NSInteger willAddIndex = [self validIndex:self.currentIndex-1];
        
        CLCycleScrollViewContentView *contentView = [self.dataSource cycleScrollView:self viewAtIndex:willAddIndex];
        [self.contentViews insertObject:contentView atIndex:0];
        NSMutableArray *tempArray = [self.reusableViewDic objectForKey:contentView.identifier];
        [tempArray removeObject:contentView];
        
        //===
        [self reLayoutSubviews];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{    
    [self.autoTimer resumeTimerAfterTimeInterval:self.autoScrollDuration];
}

@end

@interface CLCycleScrollViewContentView () <UIScrollViewDelegate>

@property (nonatomic, copy) NSString *identifier;

@property (nonatomic, retain) UITapGestureRecognizer *doubleTapGesture;

@end

@implementation CLCycleScrollViewContentView

- (void)dealloc
{
    FNRELEASE(_identifier);
    
    FNRELEASE(_doubleTapGesture);
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame identifier:(NSString *)identifier
{
    if (self = [super initWithFrame:frame]) {
        self.identifier = identifier;
        
        self.backgroundColor = [UIColor blueColor];
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.minimumZoomScale = 1;
        self.delegate = self;
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomContentView)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
        self.doubleTapGesture = doubleTap;
        [doubleTap release];
    }
    
    return self;
}

- (void)zoomContentView
{
    CGFloat scale = (self.zoomScale == self.maximumZoomScale) ? self.minimumZoomScale : self.maximumZoomScale;
    [self setZoomScale:scale animated:YES];
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
    NSLog(@"will beign zoom");
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    NSLog(@"did zoom");
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    [scrollView setZoomScale:scale animated:NO];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    for (UIView *subView in self.subviews)
        return subView;
    
    return nil;
}

@end

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
