#CLCycleScrollView
```
CLCycleScrollView *scroll = [[CLCycleScrollView alloc] initWithFrame:CGRectMake(80, 100, 160, 400)];//initWithFrame:self.view.bounds];//
    scroll.backgroundColor = [UIColor yellowColor];
    scroll.dataSource = self;
    scroll.delegate = self;
    scroll.autoScrollDuration = 1.0;
    //scroll.maxZoomScale = 1.5;
    scroll.interspaceWidth = 20;
    [self.view addSubview:scroll];
    [scroll release];
```

####CLCycleScrollViewDataSource
```
- (NSInteger)numberOfViewsInCycleScrollView:(CLCycleScrollView *)scrollView
{
    return 10;
}
```
```
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
```

####CLCycleScrollViewDelegate
```
- (void)cycleScrollView:(CLCycleScrollView *)scrollView willShowViewAtIndex:(NSInteger)index
{
    self.control.currentPage = index;
}
```
```
- (void)cycleScrollView:(CLCycleScrollView *)scrollView didSelectViewAtIndex:(NSInteger)index
{
    NSLog(@"%ld", (long)index);
}
```
