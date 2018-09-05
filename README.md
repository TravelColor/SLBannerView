# SLBannerView【快捷创建高性能轮播图】
The advertising rotation diagram in the App is packaged into an independent module to simplify the development process

-  SLBannerViewDemo <https://github.com/TravelColor/SLBannerView>
-  个人邮箱：songleitravel@163.com
### Preview gif 
 ![预览GIF](http://www.code4app.com/data/attachment/forum/201809/02/120544m8o9xht800dh04fg.gif)
## Installation 【安装】
### From CocoaPods 【使用CocoaPods】
```
//最新版本
 pod 'SLBannerView'
 或者
 //指定版本
 pod 'SLBannerView', '~> 1.0.3'
```
## The basic use 【基本使用】
-   下载好SLBannerView, 只需要将工程内的同名文件夹导入项目中即可使用！使用简单！开发效率高
```objc

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

//7.如果将要传入的数组有空值或图片路径不正确，建议在传入前设置占位图,否则第一次运行不显示占位图，
//  如果将要传入的数组不为空和图片路径都正确，占位图可不设
banner.placeholderImg = [UIImage imageNamed:@"SLPlaceholderImageName.jpg"];

//3. 必须：需要传入的图片数组和可选的标题数组
banner.slImages = @[
@"2.jpg",
@"http://img3.duitang.com/uploads/item/201601/03/20160103215632_M48zu.thumb.700_0.jpeg",
@"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=3531763848,1750613639&fm=26&gp=0.jpg",
@"http://www.gx8899.com/uploads/allimg/2017092011/334mgqfbcjw-lp.jpg",
@"未知路径，建议设置占位图"];

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

/**
SLBannerViewDelegate Method

@param banner 返回的banner对象
@param index 点击的页码
*/
- (void)bannerView:(SLBannerView *)banner didClickImagesAtIndex:(NSInteger)index
{
NSLog(@"++++++++++songlei点击了%ld ++++++++++", index);
}

@end

```


- 思路及改进说明：
1.    构建基本UI
        1.1   封装
2.    设置scrollView代理
3.    添加scrollView的image
4.    分页
5.    定时器滚动起来
6.   定时器线程阻塞问题：
            原因：NSTimer 默认是放到系统的主线程的，当用户操作其他主线程任务时，会造成NSTimer的线程阻塞，用户停止其他操作时又会重启NSTimer
            解决：设置timer在runloop中模式为CommonModes
7.    解决轮播图片过多的性能问题，循环重用ImageView
8.    添加xib创建方法
9.    巧用代理UIScrollViewDelegate，scrollViewDidScroll:定位当前正确的页数，找出最中间的哪个图片控件
10.    用SLBannerViewDelegate实现监听点击事件
11.   利用继承、内存缓存、磁盘缓存、异步并行多线程解决重复下载图片，UI不流畅的问题。先检查内存、磁盘中有没有，没有再下载，有就直接使用。
12.  修复bug,让其默认从第0页开始，给self.pageCtrl.currentPage = 0;，[imageView asynSetImage:self.slImages[0]];
13.   修复bug, 让其加载完成，就展示第二个imageView: self.scrollView.contentOffset = CGPointMake(BannerViewWidth, 0);
14.  如果将要传入的数组有空值或图片路径不正确，建议在传入前设置占位图
- 版本1.0.2 删除占位图片
- 版本1.0.3 增加占位图片
 ```objc
 
 // 设置占位图片，pods不显示
 
 //        if (placeholderImgName) {
 //         [self setImage:[UIImage imageNamed:placeholderImgName]];//pods导入后，不显示占位图。直接拖到工程里可以显示
 //            NSBundle *bundle = [NSBundle bundleWithIdentifier:@"org.cocoapods.SLBannerView"];
 //            [self setImage:[UIImage imageNamed:@"SLPlaceholderImageName.jpg" inBundle:bundle compatibleWithTraitCollection:nil]];//查百度的方法，也不显示。后续再更新。如果有好的方法和建议， 请Pull Requests我
 //        }
 ```
- 查阅了部分百度知识点，自己封装，在维护。暂未发现bug
- Copyright © 2018年 Travelcolor. All rights reserved.
### 结语
- 如果你在使用过程中遇到Bug，希望你能Issues我
- 如果在使用过程中发现功能不够用，希望你能Issues我，我非常想为这个框架增加更多好用的功能，谢谢
- 如果你想为SLBannerView输出代码，请Pull Requests, 非常感谢
- 如果好用，请点击star, 万分感谢
