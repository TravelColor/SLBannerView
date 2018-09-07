//
//  SLBannerView.m
//  SLBannerViewDemo <https://github.com/TravelColor/SLBannerView>
//  个人邮箱：songleitravel@163.com
//  Created by 宋雷 on 2018/8/31.
//  Copyright © 2018年 Travelcolor. All rights reserved.
//

#import "SLBannerView.h"

#pragma mark - SLImageView
@interface SLImageView : UIImageView

/** 内存缓存 */
@property (nonatomic, strong) NSMutableDictionary *mDicImages;
- (void)asynSetImage:(NSString *)imagePath placeholderImage:(UIImage *)placeholderImg;

@end

@implementation SLImageView

- (NSMutableDictionary *)mDicImages
{
    if (!_mDicImages) {
        _mDicImages = [NSMutableDictionary dictionary];
    }
    return _mDicImages;
}
/** 优化图片设置 */
- (void)asynSetImage:(NSString *)imagePath placeholderImage:(UIImage *)placeholderImg
{
    if (imagePath == nil || imagePath.length == 0)
    {
        //改进：设置占位图片
        if (placeholderImg) {
         [self setImage:placeholderImg];
        }
        return;
    }
    // 网络地址,或沙盒路径URL
    if ([imagePath containsString:@"http"] || [imagePath containsString:@"file://"])
    {
        //1. __block 便于在block中使用 2.尝试去内存中取图片
        __block UIImage *image = [self.mDicImages objectForKey:imagePath];
        //如果内存中有，直接赋值，否则检查磁盘缓存
        if (image) {
            [self setImage:image];
        }else{
            //2. 保存图片到沙盒缓存
            NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
            //2.1 获得图片的名称，不包含/
            NSString *imageName = [imagePath lastPathComponent];
            //2.2 拼接图片的全路径
            NSString *fullPath = [cachesPath stringByAppendingPathComponent:imageName];
            
            NSData *imageDataCaches = [NSData dataWithContentsOfFile:fullPath];
            //检查磁盘缓存，如果磁盘中有，直接赋值, 没有就下载
            if (imageDataCaches) {
                UIImage *imageCaches = [UIImage imageWithData:imageDataCaches];
                [self setImage:imageCaches];
                //并保存到内存中
                [self.mDicImages setObject:imageCaches forKey:imagePath];
                
            }else{
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    //网络下载图片 NSData格式
                    NSError *error;
                    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imagePath] options:NSDataReadingMappedIfSafe error:&error];
                    if (imageData) {
                        image = [UIImage imageWithData:imageData];
                        
                        //1. 下载完图片之后保存到内存中
                        [self.mDicImages setObject:image forKey:imagePath];
                        
                        //2.3 写数据到磁盘
                        [imageData writeToFile:fullPath atomically:YES];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self setImage:image];
                    });
                });
            }
        }
        
        return;
    }
    
    UIImage *image = [UIImage imageNamed:imagePath];
    if (image)
    {
        [self setImage:image];
    }else{
        //改进：设置占位图片
        [self setImage:placeholderImg];
    }
}
@end

#define SLBannerViewWidth self.bounds.size.width
#define SLBannerViewHeight self.bounds.size.height

//固定创建3个imageView进行循环复用，性能体验最好
//每次给iamges赋值的时候进行判断当前是第几张图片，是第几页。ImageView在轮播的过程中要通过计算切换图片和页码
static int imagesCount = 3;

@interface SLBannerView () <UIScrollViewDelegate>

/** 滚动视图 */
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
/** 页控制 圆点 */
@property (nonatomic, weak) IBOutlet UIPageControl *pageCtrl;
/** 定时器,用weak */
@property (nonatomic, weak) NSTimer *timer;

@end

@implementation SLBannerView

#pragma mark - 创建方法
/** xib快速构造方法 */
+ (instancetype)bannerViewXib
{
//    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
#define SLBannerViewBundle [NSBundle bundleForClass:[self class]]
    return [SLBannerViewBundle loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

/** xib 创建 */
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setup];
}

/** 代码快速构造方法 */
+ (instancetype)bannerView
{
    return [[self alloc] init];
}

/** 代码创建 */
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //创建子控件
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        
        UIPageControl *pageCtrl = [[UIPageControl alloc] init];
        [self addSubview:pageCtrl];
        self.pageCtrl = pageCtrl;

        [self setup];
    }
    return self;
}
#pragma mark - 控件设置
/** 基础设置 */
- (void)setup
{
    //设置时间间隔
    _imgStayTimeInterval = 2;
    _durTimeInterval = 0.3;
    
    for (int i = 0; i < imagesCount; i++) {
        SLImageView *imageView = [[SLImageView alloc] initWithFrame:CGRectMake(i * SLBannerViewWidth, 0, SLBannerViewWidth, SLBannerViewHeight)];
        [self.scrollView addSubview:imageView];
        
        //给每个pic设置点击手势
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClicked:)];
        [imageView addGestureRecognizer:tap];
    }
    
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(imagesCount * SLBannerViewWidth, 0);
    
    //pageCtrl的当前页背景颜色和默认颜色
    self.pageCtrl.currentPageIndicatorTintColor = [UIColor redColor];
    self.pageCtrl.pageIndicatorTintColor = [UIColor lightGrayColor];
    self.pageCtrl.hidesForSinglePage = YES;
    
}
/** 重新布局子控件 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //重写scroll的布局
    self.scrollView.frame = self.bounds;
    //不重新设置contentSize，无法用手势拖动图片
    self.scrollView.contentSize = CGSizeMake(imagesCount * SLBannerViewWidth, 0);
    
    for (int i = 0; i < imagesCount; i++) {
        SLImageView *imageView = self.scrollView.subviews[i];
        imageView.frame = CGRectMake(i * SLBannerViewWidth, 0, SLBannerViewWidth, SLBannerViewHeight);
    }
    //重写pageCtrl的布局，默认居中，可根据项目需求修改位置
    CGFloat pageCtrlW = 60;
    CGFloat pageCtrlH = 40;
    CGFloat pageCtrlX = (SLBannerViewWidth - pageCtrlW) / 2;
    CGFloat pageCtrlY = SLBannerViewHeight - pageCtrlH;
    self.pageCtrl.frame = CGRectMake(pageCtrlX, pageCtrlY, pageCtrlW, pageCtrlH);
    
    //重写titleLabel的布局
    CGFloat titleH = 40;
    self.titleLabel.frame = CGRectMake(0, SLBannerViewHeight - titleH, SLBannerViewWidth, titleH);
    //1. 修复bug,让其默认从第0页开始
    self.pageCtrl.currentPage = 0;
    SLImageView *imageView = self.scrollView.subviews[0];
    [imageView asynSetImage:self.slImages[0] placeholderImage:self.placeholderImg];
    //2. 修复bug, 让其加载完成，就展示第二个imageView
    self.scrollView.contentOffset = CGPointMake(SLBannerViewWidth, 0);
    
}

/** 设置单张图片不轮播 */
- (void)setupSingleImage
{
    SLImageView *imageView = [[SLImageView alloc] initWithFrame:self.bounds];
    [self addSubview:imageView];
    [imageView asynSetImage:self.slImages.firstObject placeholderImage:_placeholderImg];
    imageView.tag = 0;
    //给pic设置点击手势
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClicked:)];
    [imageView addGestureRecognizer:tap];
}

#pragma mark - 重写slImages，slTitles的set方法
- (void)setSlImages:(NSArray *)slImages
{
    //保存图片数组
    if (_slImages != slImages)
    {
        _slImages = slImages;
    }
    //当图片数组大于一张时启动轮播
    if (slImages.count > 1)
    {
        //设置pageCtrl
        self.pageCtrl.numberOfPages = slImages.count;
        self.pageCtrl.currentPage = 0;
        
        //设置内容
        [self setupContent];
        
        //开始定时器
        [self startTimer];
    } else {
        //单张移除子视图，并设置一张图片不轮播
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self setupSingleImage];
    }
    
}

- (void)setSlTitles:(NSArray *)slTitles
{
    if (_slTitles != slTitles)
    {
        _slTitles = slTitles;
    }
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    //默认第一条标题
    titleLabel.text = slTitles.firstObject;
}

/** 设置内容 */
- (void)setupContent
{
    // 这是一个循环 设置图片，页码，复用UIImageView
    for (int i = 0; i < self.scrollView.subviews.count; i++) {//3
        SLImageView *imageView = self.scrollView.subviews[i];//1. 0
        NSInteger index = self.pageCtrl.currentPage;
        if (i == 0) {
            index--;//1. -1
        }else if (i == 2){
            index++;//
        }
        
        if (index < 0) {
            index = self.pageCtrl.numberOfPages - 1;//1. 3
        }else if (index >= self.pageCtrl.numberOfPages){
            index = 0;
        }
        imageView.tag = index;//1. 3  2.0  3.1
        //        imageView.image = [UIImage imageNamed:self.slImages[index]];
        //异步优化图片设置
        [imageView asynSetImage:self.slImages[index] placeholderImage:_placeholderImg];//1. 3   2.0  3.1
        
        
        //同时设置title (图片和标题是对应的, 但是当前title和当前要展示的image属于错位1个单位的关系,实际上是延迟了一个单位，所以需要重新计算)
        self.titleLabel.text = self.slTitles[index];//1. 3  2. 0  3.1
    }
    
    //设置当前偏移量
    self.scrollView.contentOffset = CGPointMake(SLBannerViewWidth, 0);
    //重置偏移量之后需要重写计算对应的title (取出当前页码，减1即可)
    NSString *currentTitle = self.titleLabel.text;
    NSInteger titleIndex = [self.slTitles indexOfObject:currentTitle];
    
    titleIndex --;
    
    if (titleIndex < 0) {
        titleIndex = self.slTitles.count - 1;
    }
    
    //重写设置对应的title
    self.titleLabel.text = self.slTitles[titleIndex];
}

#pragma mark - 代理监听页码移动 UIScrollViewDelegate
// 滚动的时候定位当前正确的页数
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //找出最中间的哪个图片控件
    NSInteger page = 0;
    CGFloat minDistance = MAXFLOAT;
    for (int i = 0; i < self.scrollView.subviews.count; i++) {
        SLImageView *imageView = self.scrollView.subviews[i];
        CGFloat distance = 0;
        distance = ABS(imageView.frame.origin.x - scrollView.contentOffset.x);//整数绝对值
        if (distance < minDistance) {
            minDistance = distance;
            page = imageView.tag;
        }
    }
    //设置圆点的动画
    [UIView animateWithDuration:_durTimeInterval animations:^{
        [self.pageCtrl setCurrentPage:page];
    }];
}

/** 开始滚动的时候停止定时器 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self endTimer];
}
/** 滚动停止的时候开启定时器 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self startTimer];
}
/** 滚动结束 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self setupContent];
}
/** 滚动完成 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self setupContent];
}

#pragma mark - 定时器
/** 重写图片停留时间的set方法 */
- (void)setImgStayTimeInterval:(NSTimeInterval)imgStayTimeInterval
{
    _imgStayTimeInterval = imgStayTimeInterval;
    [self endTimer];
    [self startTimerWithTimeInterval:imgStayTimeInterval];
}

/** 启动定时器 */
- (void)startTimerWithTimeInterval:(NSTimeInterval)timeInterval
{
    if (!_timer.isValid) {
        //该方法内部自动添加到runloop中，并且运行模式设为默认
        _timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
        //定时器线程阻塞问题，设置为Common（NSRunloopCommonModes）：模式合集。默认包括Default，Modal，Event Tracking三大模式，可以处理几乎所有事件。
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

/** 开始定时器 */
- (void)startTimer
{
    [self startTimerWithTimeInterval:_imgStayTimeInterval];
}

/** 结束定时器 */
- (void)endTimer
{
    //如果有效就让timer无效
    if (_timer.isValid) {
        [_timer invalidate];
        _timer = nil;
    }
}

/** 下一页 */
- (void)nextPage
{
    //3张图片，始终展示的是第二张图片，偏移量需要设置为2倍的banner宽度，才能从第二张，偏移到第三张，以此复用
    [self.scrollView setContentOffset:CGPointMake(2 * SLBannerViewWidth, 0) animated:YES];
    
}

#pragma mark - SLBannerViewDelegate代理方法，监听点击的哪一个imageView
/**
 点击了哪一张图片
 
 @param tap 手势点击
 */
- (void)imageViewClicked:(UITapGestureRecognizer *)tap
{
    SLImageView *imageView = (SLImageView *)tap.view;
    if ([self.delegate respondsToSelector:@selector(bannerView:didClickImagesAtIndex:)]) {
        [self.delegate bannerView:self didClickImagesAtIndex:imageView.tag];
    }
}

/**
 当本视图的父类视图改变的时候，系统会自动执行此方法，新父类视图有可能是nil

 @param newSuperview 新的父类视图
 */
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (!newSuperview && self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

@end
