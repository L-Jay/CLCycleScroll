//
//  TestZoomViewController.m
//  CLCycleScrollView
//
//  Created by L on 14-7-2.
//  Copyright (c) 2014年 L. All rights reserved.
//

#import "TestZoomViewController.h"
#import "MyScrollView.h"

@interface TestZoomViewController () <UIScrollViewDelegate>

@property (nonatomic, retain) NSMutableArray *views;

@property (nonatomic) NSInteger index;

@property (nonatomic, retain) UIScrollView *scroll;

@property (nonatomic, retain) UIScrollView *zoomScroll;

@property (nonatomic, retain) UITapGestureRecognizer *tapGesture;

@end

@implementation TestZoomViewController

- (void)dealloc
{
    [_views release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scroll.pagingEnabled = YES;
    scroll.contentSize = CGSizeMake(scroll.width*3, 0);
    scroll.delegate = self;
    scroll.tag = 1000;
//    scroll.minimumZoomScale = 1;
//    scroll.maximumZoomScale = 2;
    [self.view addSubview:scroll];
    self.scroll = scroll;
    [scroll release];
    
    UIScrollView *zoomScroll = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    zoomScroll.delegate = self;
    zoomScroll.tag = 2000;
    zoomScroll.minimumZoomScale = 1;
    zoomScroll.maximumZoomScale = 2;
    self.zoomScroll = zoomScroll;
    [zoomScroll release];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomContentView:)];
    doubleTap.numberOfTapsRequired = 2;
    self.tapGesture = doubleTap;
    [doubleTap release];
    
    self.views = [NSMutableArray array];
    for (int i = 0; i < 3; i++) {
//        MyScrollView *m_scroll = [[MyScrollView alloc] initWithFrame:scroll.bounds];
//        m_scroll.minX = i*scroll.width;
//        m_scroll.image = [UIImage imageNamed:[NSString stringWithFormat:@"welcome_%d.png", i]];
//        [scroll addSubview:m_scroll];
//        [self.views addObject:m_scroll];
//        [m_scroll release];
        
        /*
        ZoomView *zoom = [[ZoomView alloc] initWithFrame:scroll.bounds];
        zoom.minX = i*scroll.width;
        
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"welcome_%d.png", i]];
        UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
        imgView.frame = scroll.bounds;
        //imgView.minX = i*scroll.width;
        [zoom addSubview:imgView];
        [scroll addSubview:zoom];
        [self.views addObject:zoom];
        [imgView release];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomContentView:)];
        doubleTap.numberOfTapsRequired = 2;
        [zoom addGestureRecognizer:doubleTap];
        [doubleTap release];*/
        
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"welcome_%d.png", i]];
        UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
        imgView.frame = scroll.bounds;
        imgView.userInteractionEnabled = YES;
        
        if (i == 1) {
            self.zoomScroll.minX = i*scroll.width;
            [imgView addGestureRecognizer:self.tapGesture];
            [self.zoomScroll addSubview:imgView];
            [self.scroll addSubview:self.zoomScroll];
        }else {
            imgView.minX = i*scroll.width;
            [scroll addSubview:imgView];
        }
        
        [self.views addObject:imgView];
        [imgView release];
    }
    
//    UIButton *nexBT = [UIButton buttonWithType:UIButtonTypeCustom];
//    nexBT.frame = CGRectMake(270, 200, 50, 50);
//    nexBT.backgroundColor = [UIColor orangeColor];
//    [nexBT addTarget:self action:@selector(zoomView) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:nexBT];
}

- (void)zoomContentView:(UIGestureRecognizer *)gesture
{
//    UIScrollView *view = (UIScrollView *)gesture.view;
//    
//    CGFloat scale = view.zoomScale == view.maximumZoomScale ? view.minimumZoomScale : view.maximumZoomScale;
//    NSLog(@"SCALE %f", scale);
//    [view setZoomScale:scale animated:YES];
    

//    CGFloat scale = self.zoomScroll.zoomScale == self.zoomScroll.maximumZoomScale ? self.zoomScroll.minimumZoomScale : self.zoomScroll.maximumZoomScale;
//    NSLog(@"SCALE %f", scale);
//    [self.zoomScroll setZoomScale:scale animated:YES];
    
    [self.zoomScroll zoomToRect:CGRectMake(0, 0, 100, 100) animated:YES];

}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if (scrollView.tag == 2000) {
        return [self.views objectAtIndex:1];
    }
    
    return nil;
}


@end

@interface ZoomView () <UIScrollViewDelegate>

@end

@implementation ZoomView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.minimumZoomScale = 1.0;
        self.maximumZoomScale = 2.5;
        self.delegate = self;
    }
    
    return self;
}

//- (void)zoomView
//{
//    CGFloat scale = self.zoomScale == self.maximumZoomScale ? self.minimumZoomScale : self.maximumZoomScale;
//    [self setZoomScale:scale animated:YES];
//}

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
    NSLog(@"end zoom");
    
    [scrollView setZoomScale:scale animated:NO];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    for (UIView *subView in scrollView.subviews)
        return subView;
    
    return nil;
}

@end
