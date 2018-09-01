//
//  ViewController.m
//  SLBannerViewDemo
//  个人邮箱：songleitravel@163.com
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
    
    //1.1 不建议
    //    SLBannerView *banner = [[SLBannerView alloc] init];
    //1.2 建议：xib快速创建
//        SLBannerView *banner = [SLBannerView bannerViewXib];
    //1.3 建议：代码快速创建
    SLBannerView *banner = [SLBannerView bannerView];
    
    //2. banner 的位置和大小
    banner.frame = CGRectMake(0, 50, SLBannerWidth, SLBannerWidth);
    
    //3. 必须：需要传入的图片数组和可选的标题数组
    banner.slImages = @[
                        @"2.jpg",
                        @"http://img3.duitang.com/uploads/item/201601/03/20160103215632_M48zu.thumb.700_0.jpeg",
                        @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=3531763848,1750613639&fm=26&gp=0.jpg",
                        @"http://www.gx8899.com/uploads/allimg/2017092011/334mgqfbcjw-lp.jpg",
                        @"http://www.gx8899.com/uploads/allimg/2017092011/pk3iunzqdkd-lp.jpg"];
    
    //工程图片
//    banner.slImages = @[@"1.jpg", @"2.jpg", @"3.jpg", @"4.jpg", @"5.jpg"];
    
    //可选：设置标题
//    banner.slTitles = @[@"第1张图片的标题", @"第2张图片的标题", @"第3张图片的标题", @"第4张图片的标题",@" 第5张图片的标题"];
    
    [banner.titleLabel setTextColor:[UIColor yellowColor]];
    //4. 监听设置代理
    banner.delegate = self;
    //5. banner添加到UI上
    [self.view addSubview:banner];
    
    //6. 可选设置动画，建议动画持续时间小于停留时间
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
 1.1   封装
 2.    设置scrollView代理
 3.    添加scrollView的image
 4.    分页
 5.    定时器滚动起来
 5.1   定时器线程阻塞问题：
        原因：NSTimer 默认是放到系统的主线程的，当用户操作其他主线程任务时，会造成NSTimer的线程阻塞，用户停止其他操作时又会重启NSTimer
        解决：设置timer在runloop中模式为CommonModes
 6.    解决轮播图片过多的性能问题，循环重用ImageView
 7.    添加xib创建方法
 8.    巧用代理UIScrollViewDelegate，scrollViewDidScroll:定位当前正确的页数，找出最中间的哪个图片控件
 9.    用SLBannerViewDelegate实现监听点击事件
 10.   利用继承、内存缓存、磁盘缓存、异步并行多线程解决重复下载图片，UI不流畅的问题。先检查内存、磁盘中有没有，没有再下载，有就直接使用。
 11.1.  修复bug,让其默认从第0页开始，给self.pageCtrl.currentPage = 0;，[imageView asynSetImage:self.slImages[0]];
 11.2   修复bug, 让其加载完成，就展示第二个imageView: self.scrollView.contentOffset = CGPointMake(BannerViewWidth, 0);
 */

@end
