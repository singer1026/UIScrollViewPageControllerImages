//
//  ViewController.m
//  UIScrollView分页
//
//  Created by Singer on 14-6-16.
//  Copyright (c) 2014年 Singer. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    UIPageControl *_pageControl;
    UIScrollView *_scrollView;
    NSMutableArray *_views;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _views = [[NSMutableArray alloc] init];
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    scrollView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:scrollView];
    
    CGFloat scrollViewWidth = scrollView.frame.size.width;
    CGFloat scrollViewHeight = scrollView.frame.size.height;
    
    for (int i = 0; i < 5; i++) {
        UIScrollView *scroll = [[UIScrollView alloc] init];
        scroll.frame =
        CGRectMake(scrollViewWidth * i, 0, scrollViewWidth, scrollViewHeight);
        
        CGFloat scrollWidth = scroll.frame.size.width;
        CGFloat scrollHeight = scroll.frame.size.height;
        
        scroll.contentSize = CGSizeMake(scrollView.frame.size.width, 0);
        //设置放大
        scroll.maximumZoomScale = 2;
        scroll.minimumZoomScale = 0.5;
        
        scroll.delegate = self;
        
        UIImageView *imageView = [[UIImageView alloc] init];
        UIImage *image =
        [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg", i]];
        imageView.image = image;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        imageView.frame = CGRectMake(0, 0, scrollWidth, scrollHeight);
        [scroll addSubview:imageView];
        [scrollView addSubview:scroll];
        
        [_views addObject:scroll];
    }
    
    //设置滚动范围
    scrollView.contentSize = CGSizeMake(5 * scrollView.frame.size.width, 0);
    
    //隐藏水平滚动条
    scrollView.showsHorizontalScrollIndicator = NO;
    
    //开启分页
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    
    //添加分页的小点
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.bounds = CGRectMake(0, 0, 150, 150);
    pageControl.center = CGPointMake(scrollView.frame.size.width * 0.5,
                                     scrollView.frame.size.height - 50);
    [pageControl setNumberOfPages:5];
    [self.view addSubview:pageControl];
    [pageControl addTarget:self
                    action:@selector(pageChange)
          forControlEvents:UIControlEventValueChanged];
    
    _pageControl = pageControl;
    _scrollView = scrollView;
}

#pragma mark 告诉控制器是哪个view需要放大
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    NSArray *subViews = scrollView.subviews;
    return subViews[0];
}

#pragma mark 把图片恢复到原来的缩放比例
- (void)zoomImages {
    for (UIScrollView *view in _views) {
        view.zoomScale = 1;
        UIImageView *imageView = view.subviews[0];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
}

#pragma mark 滑动结束后修改分页 并且把图片恢复到原来的缩放比例
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int pageNum = scrollView.contentOffset.x / scrollView.frame.size.width;
    _pageControl.currentPage = pageNum;
    [self zoomImages];
}

#pragma mark - 点击页码发生变化后修改内容
- (void)pageChange {
    CGPoint offset = _scrollView.contentOffset;
    offset.x = _pageControl.currentPage * _scrollView.frame.size.width;
    [UIView beginAnimations:nil context:nil];
    _scrollView.contentOffset = offset;
    [UIView commitAnimations];
    [self zoomImages];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
