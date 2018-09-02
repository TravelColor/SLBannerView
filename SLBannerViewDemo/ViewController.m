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
    
    //3. 必须：需要传入的图片数组和可选的标题数组，图片不能为空
    banner.slImages = @[
                        @"2.jpg",
                        @"http://img3.duitang.com/uploads/item/201601/03/20160103215632_M48zu.thumb.700_0.jpeg",
                        @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=3531763848,1750613639&fm=26&gp=0.jpg",
                        @"http://www.gx8899.com/uploads/allimg/2017092011/334mgqfbcjw-lp.jpg",
                        @"3.jpg"];
    
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
    NSLog(@"++++++++++宋雷 点击了%ld ++++++++++", index);
}

@end
