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
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define SLNAVIGATION_BAR_HEIGHT (iPhoneX ? 88.f : 64.f)

- (void)viewDidLoad {
    [super viewDidLoad];
    /**
     关键代码：1.3 --> 2 --> 3 --> 5，可快速创建轮播图
     */
    //1.1 不建议
    //    SLBannerView *banner = [[SLBannerView alloc] init];
    //1.2 建议：xib快速创建
//        SLBannerView *banner = [SLBannerView bannerViewXib];
    //1.3 建议：代码快速创建
    SLBannerView *banner = [SLBannerView bannerView];
    
    //2. banner 的位置和大小
    banner.frame = CGRectMake(0, SLNAVIGATION_BAR_HEIGHT, SLBannerWidth, SLBannerWidth);
    
    
    //7.如果将要传入的数组有空值或图片路径不正确，建议在传入前设置占位图,否则第一次运行不显示占位图，
    //如果将要传入的数组不为空和图片路径都正确，占位图可不设
    banner.placeholderImg = [UIImage imageNamed:@"SLPlaceholderImageName.jpg"];
    //3. 需要传入的图片数组，如果设置了占位图，数组可以传空
    banner.slImages = @[
                        @"2.jpg",
                        @"http://img3.duitang.com/uploads/item/201601/03/20160103215632_M48zu.thumb.700_0.jpeg",
                        @"未知路径，显示占位图",
                        @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1535866967519&di=5faf2fc5574462a62fae61b81b5a0935&imgtype=0&src=http%3A%2F%2Fpic31.nipic.com%2F20130708%2F7447430_090100939000_2.jpg",
                        @"http://img.zcool.cn/community/01b34f58eee017a8012049efcfaf50.jpg@1280w_1l_2o_100sh.jpg"];
    
    //工程图片
//    banner.slImages = @[@"1.jpg", @"2.jpg", @"3.jpg", @"4.jpg", @"5.jpg"];
    
    //设置标题
    banner.slTitles = @[@"第1张图片的标题", @"第2张图片的标题", @"第3张图片的标题", @"第4张图片的标题",@" 第5张图片的标题"];
    
    [banner.titleLabel setTextColor:[UIColor yellowColor]];
    //4. 监听设置代理
    banner.delegate = self;
    //5. banner添加到UI上
    [self.view addSubview:banner];
    
    //6. 自定义动画时间，建议动画持续时间小于停留时间
    banner.durTimeInterval = 0.2;
    banner.imgStayTimeInterval = 2.5;
    
}

/**
 SLBannerViewDelegate Method
 
 @param banner 返回的banner对象
 @param index 点击的页码
 */
- (void)bannerView:(SLBannerView *)banner didClickImagesAtIndex:(NSInteger)index
{
    NSLog(@"++++++++++songlei 点击了%ld ++++++++++", index);
}

@end
