//
//  SLShufflingFigureView.m
//  DiDiProject
//
//  Created by Travelcolor on 2018/8/22.
//  Copyright © 2018年 Travelcolor. All rights reserved.
//

#import "SLShufflingFigureView.h"

@interface SLShufflingFigureView () <UIScrollViewDelegate>

/** 滚动视图 */
@property (nonatomic, strong) UIScrollView *scrollView;
/** 页控制 圆点 */
@property (nonatomic, strong) UIPageControl *pageCtrl;
/** 定时器 */
@property (nonatomic, weak) NSTimer *timer;
//多少张图片
@property (nonatomic, assign) NSInteger imgCount;

@end

@implementation SLShufflingFigureView

- (instancetype)initWithFrame:(CGRect)frame images:(NSArray *)imgArray
{
    if (self = [super initWithFrame:frame])
    {
        self.imgCount = imgArray.count;
        CGFloat scrollWidth = frame.size.width;
        CGFloat scrollHeight = frame.size.height;
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, scrollWidth, scrollHeight)];
        [self addSubview:scrollView];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.pagingEnabled = YES;
        scrollView.contentSize = CGSizeMake(scrollWidth * self.imgCount, 0);
        scrollView.delegate = self;
        self.scrollView = scrollView;
        
        for (int i = 0; i < self.imgCount; i++)
        {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * scrollWidth, 0, scrollWidth, scrollHeight)];
            imageView.image = [UIImage imageNamed:imgArray[i]];
            [scrollView addSubview:imageView];
        }
        
        CGFloat pageCtrlWidth = 20 * self.imgCount;
        CGFloat pageCtrlHeight = 30;
        UIPageControl *pageCtrl = [[UIPageControl alloc] initWithFrame:CGRectMake((scrollWidth - pageCtrlWidth) / 2, scrollHeight - pageCtrlHeight, pageCtrlWidth, pageCtrlHeight)];
        pageCtrl.numberOfPages = self.imgCount;
        //单页隐藏pageControl
        pageCtrl.hidesForSinglePage = YES;
        //    pageCtrl.currentPage = 1;
        pageCtrl.pageIndicatorTintColor = [UIColor lightGrayColor];
        pageCtrl.currentPageIndicatorTintColor = [UIColor redColor];
        [self addSubview:pageCtrl];
        self.pageCtrl = pageCtrl;
        
        [self startTimer];
    }
    return self;
}

/**
 开始定时器
 */
- (void)startTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

/**
 结束定时器
 */
- (void)endTimer
{
    [self.timer invalidate];
}

- (void)nextPage
{
    NSInteger page = self.pageCtrl.currentPage + 1;
    if (page == self.imgCount) {
        page = 0;
    }
    [self.scrollView setContentOffset:CGPointMake(page * self.frame.size.width, 0) animated:YES];

}

#pragma mark --UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.x;
    CGFloat scrollVWidth = scrollView.frame.size.width;
    NSInteger page = offset / scrollVWidth + 0.5;
    self.pageCtrl.currentPage = page;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self endTimer];
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self startTimer];
}

@end
