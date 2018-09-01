//
//  SLBannerView.h
//  ShufflingDemo
//
//  Created by 宋雷 on 2018/8/31.
//  Copyright © 2018年 Travelcolor. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SLBannerView;
@protocol SLBannerViewDelegate <NSObject>

@optional
/** 监听点击的图片 */
- (void)bannerView:(SLBannerView *)banner didClickImagesAtIndex:(NSInteger)index;

@end

@interface SLBannerView : UIView

/** 每张图片的停留时间，默认2秒 */
@property (nonatomic, assign) NSTimeInterval imgStayTimeInterval;
/** 图片的切换动画持续时间，默认0.3秒 */
@property (nonatomic, assign) NSTimeInterval durTimeInterval;
/** sl要展示的图片数组,必须要传入图片（网络，本地，工程图片可用） */
@property (nonatomic, strong) NSArray *slImages;
/** 要展示的标题数组,可选传入标题 */
@property (nonatomic, strong) NSArray *slTitles;

/** 标题label,可选修改字体大小位置颜色 */
@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) id <SLBannerViewDelegate> delegate;

/** xib快速构造方法 */
+ (instancetype)bannerViewXib;
/** 代码快速构造方法 */
+ (instancetype)bannerView;
/**
 注：圆点页码控制，默认靠下居中
 */
@end
