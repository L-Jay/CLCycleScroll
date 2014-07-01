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

@end

@implementation RootViewController

- (void)dealloc
{
    FNRELEASE(_control);
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    CLCycleScrollView *scroll = [[CLCycleScrollView alloc] initWithFrame:self.view.bounds];//initWithFrame:CGRectMake(80, 100, 160, 400)];//
    scroll.dataSource = self;
    scroll.delegate = self;
    [self.view addSubview:scroll];
    [scroll release];
        
    UIPageControl *control = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, scroll.width, 20)];
    control.maxY = scroll.height - 20;
    control.numberOfPages = 10;
    [self.view addSubview:control];
    self.control = control;
    [control release];
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
        NSLog(@"identifier: %@", contentView.identifier);
    }else
        NSLog(@"HAVE=====");
    
    NSLog(@"%d", index);
    
    [contentView removeAllSubviews];
    
    if (index >=0 && index < 3) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"welcome_%d.png", index]];
        UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
        imgView.frame = scrollView.bounds;
        [contentView addSubview:imgView];
        [imgView release];
    }else if (index > 4 && index < 8) {
        UILabel *label = [[UILabel alloc] initWithFrame:contentView.bounds];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:50];
        label.text = [NSString intString:index];
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
    [FNHUD showText:[NSString intString:index]];
}

@end
