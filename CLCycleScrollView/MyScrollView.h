//
//  MyScrollView.h
//  BookDemo
//
//  Created by Cui on 10-12-22.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyScrollView : UIScrollView <UIScrollViewDelegate>
{
	UIImage *image;
	UIImageView *imageView;
	
	//UIActivityIndicatorView *activity;
}

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) UIImageView *imageView;

//@property (nonatomic, retain) UIActivityIndicatorView *activity;

@end
