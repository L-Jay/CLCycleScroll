//
//  RootViewController.m
//  CLCycleScrollView
//
//  Created by L on 14-6-27.
//  Copyright (c) 2014年 L. All rights reserved.
//

#import "RootViewController.h"
#import "CLCycleScrollView.h"

@interface RootViewController ()<CLCycleScrollViewDataSource, CLCycleScrollViewDelegate>

@property (nonatomic, retain) UIPageControl *control;

@property (nonatomic, retain) UIScrollView *testScroll;

@property (nonatomic, assign) NSInteger testIndex;

@end

@implementation RootViewController

- (void)dealloc
{
    [_control release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor brownColor];
	
    CLCycleScrollView *scroll = [[CLCycleScrollView alloc] initWithFrame:CGRectMake(80, 100, 160, 400)];//initWithFrame:self.view.bounds];//
    scroll.backgroundColor = [UIColor yellowColor];
    scroll.dataSource = self;
    scroll.delegate = self;
    scroll.autoScrollDuration = 1.0;
    //scroll.maxZoomScale = 1.5;
    scroll.interspaceWidth = 20;
    [self.view addSubview:scroll];
    [scroll release];
    
//    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:self.view.bounds];
//    scroll.contentSize = CGSizeMake(scroll.width*20, 0);
//    scroll.pagingEnabled = YES;
//    for (int i = 0; i < 20; i++) {
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i*scroll.width, 0, scroll.width, scroll.height)];
//        label.textAlignment = NSTextAlignmentCenter;
//        label.backgroundColor = [UIColor colorWithRed:arc4random()%10*0.1 green:arc4random()%10*0.1 blue:arc4random()%10*0.1 alpha:1];
//        label.font = [UIFont boldSystemFontOfSize:50];
//        label.text = [NSString intString:i];
//        [scroll addSubview:label];
//        [label release];
//    }
//    
//    self.testScroll = scroll;
//    [self.view addSubview:scroll];
//    [scroll release];
    
    
    UIPageControl *control = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 20)];
    control.maxY = self.view.height - 20;
    control.numberOfPages = 10;
    [self.view addSubview:control];
    self.control = control;
    [control release];
    
    UIButton *preBT = [UIButton buttonWithType:UIButtonTypeCustom];
    preBT.frame = CGRectMake(0, 200, 50, 50);
    preBT.backgroundColor = [UIColor orangeColor];
    [preBT addTarget:scroll action:@selector(prevPage) forControlEvents:UIControlEventTouchUpInside];
    //[preBT addTarget:self action:@selector(test2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:preBT];
    
    UIButton *nexBT = [UIButton buttonWithType:UIButtonTypeCustom];
    nexBT.frame = CGRectMake(270, 200, 50, 50);
    nexBT.backgroundColor = [UIColor orangeColor];
    [nexBT addTarget:scroll action:@selector(nextPage) forControlEvents:UIControlEventTouchUpInside];
    //[nexBT addTarget:self action:@selector(test1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nexBT];
}

- (void)test1
{
    self.testIndex++;
    [self.testScroll setContentOffset:CGPointMake(self.testScroll.width*self.testIndex, 0) animated:YES];
}

- (void)test2
{
    self.testIndex--;
    [self.testScroll setContentOffset:CGPointMake(self.testScroll.width*self.testIndex, 0) animated:YES];
}

- (NSInteger)numberOfViewsInCycleScrollView:(CLCycleScrollView *)scrollView
{
    return 10;
}

- (CLCycleScrollViewContentView *)cycleScrollView:(CLCycleScrollView *)scrollView viewAtIndex:(NSInteger)index
{
    static NSString *identifier = nil;
    
    if (index >=0 && index < 3) {
        identifier = @"Type1";
    }else if (index > 3 && index < 7)
        identifier = @"Type2";
    else
        identifier = @"Type3";
    
    
    CLCycleScrollViewContentView *contentView = [scrollView dequeueReusableContentViewWithIdentifier:identifier];
    
    
    if (!contentView) {
        contentView = [[[CLCycleScrollViewContentView alloc] initWithFrame:scrollView.bounds identifier:identifier] autorelease];
        contentView.tag = index;
        contentView.backgroundColor = [UIColor colorWithRed:arc4random()%10*0.1 green:arc4random()%10*0.1 blue:arc4random()%10*0.1 alpha:1];
    }
        
    [contentView removeAllSubviews];
    
    if (index >=0 && index < 3) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"welcome_%ld.png", (long)index]];
        UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
        imgView.frame = scrollView.bounds;
        [contentView addSubview:imgView];
        [imgView release];
    }else if (index > 4 && index < 8) {
        UILabel *label = [[UILabel alloc] initWithFrame:contentView.bounds];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:50];
        label.text = [NSString stringWithFormat:@"%ld", (long)index];
        [contentView addSubview:label];
        [label release];
    }
    else {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        view.backgroundColor = [UIColor colorWithRed:arc4random()%10*0.1 green:arc4random()%10*0.1 blue:arc4random()%10*0.1 alpha:1];
        view.center = contentView.centerBounds;
        [contentView addSubview:view];
        [view release];
    }
    
    return contentView;
}

- (void)cycleScrollView:(CLCycleScrollView *)scrollView willShowViewAtIndex:(NSInteger)index
{
    self.control.currentPage = index;
}

- (void)cycleScrollView:(CLCycleScrollView *)scrollView didSelectViewAtIndex:(NSInteger)index
{
    NSLog(@"%ld", (long)index);
    //[FNHUD showText:[NSString intString:index]];
}

@end
