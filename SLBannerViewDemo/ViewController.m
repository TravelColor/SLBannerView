//
//  ViewController.m
//  SLBannerViewDemo
//
//  Created by 宋雷 on 2018/9/1.
//  Copyright © 2018年 Travelcolor. All rights reserved.
//

#import "ViewController.h"
#import "SLBannerView.h"

@interface ViewController () <SLBannerViewDelegate>

@end

@implementation ViewController

#define SLBannerWidth self.view.frame.size.width

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1.1 xib快速创建
//        SLBannerView *banner = [SLBannerView bannerViewXib];
    //1.2 代码快速创建
    SLBannerView *banner = [SLBannerView bannerView];
    //1.3 代码创建
    //    SLBannerView *banner = [[SLBannerView alloc] init];
    
    //2. banner 的位置和大小
    banner.frame = CGRectMake(0, 50, SLBannerWidth, SLBannerWidth);
    
    //3. 需要传入的图片数组和可选的标题数组
//    banner.slImages = @[
//                        @"http://www.gx8899.com/uploads/allimg/2017092012/545fya3lndh-lp.jpg",
//                        @"http://img3.duitang.com/uploads/item/201601/03/20160103215632_M48zu.thumb.700_0.jpeg",
//                        @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=3531763848,1750613639&fm=26&gp=0.jpg",
//                        @"http://www.gx8899.com/uploads/allimg/2017092011/334mgqfbcjw-lp.jpg",
//                        @"http://www.gx8899.com/uploads/allimg/2017092011/pk3iunzqdkd-lp.jpg"];
    
    banner.slImages = @[@"1.jpg", @"2.jpg", @"3.jpg", @"4.jpg", @"5.jpg"];
    //可以不设置标题
//    banner.slTitles = @[@"第1张图片的标题", @"第2张图片的标题", @"第3张图片的标题", @"第4张图片的标题",@" 第5张图片的标题"];
    
    [banner.titleLabel setTextColor:[UIColor yellowColor]];
    //4. 监听设置代理
    banner.delegate = self;
    //5. 添加到UI上
    [self.view addSubview:banner];
    
    //6. 设置动画，建议动画持续时间小于停留时间
    banner.durTimeInterval = 0.5;
    banner.imgStayTimeInterval = 3;
}

/**
 SLBannerViewDelegate Method
 
 @param banner 返回的banner对象
 @param index 点击的页码
 */
- (void)bannerView:(SLBannerView *)banner didClickImagesAtIndex:(NSInteger)index
{
    NSLog(@"++++++++++点击了%ld ++++++++++", index);
}

/**
 思路：
 1.    构建基本UI
 1.1   引入封装概念
 2.    设置scrollView代理
 3.    添加scrollView的image
 4.    分页
 5.    定时器滚动起来
 5.1   定时器线程阻塞问题：
        原因：NSTimer 默认是放到系统的主线程的，当用户操作其他主线程任务时，会造成NSTimer的线程阻塞，用户停止其他操作时又会重启NSTimer
        解决：设置timer在runloop中模式为CommonModes
 6.    解决轮播图片过多的性能问题，循环复用对应的ImageView
 7.    添加xib创建方法
 */

@end
