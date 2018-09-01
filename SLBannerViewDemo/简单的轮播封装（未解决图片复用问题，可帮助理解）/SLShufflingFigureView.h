//
//  SLShufflingFigureView.h
//  DiDiProject
//
//  Created by Travelcolor on 2018/8/22.
//  Copyright © 2018年 Travelcolor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLShufflingFigureView : UIView

/** 一句代码创建轮播图，设置位置和图片数组 */
- (instancetype)initWithFrame:(CGRect)frame images:(NSArray *)imgArray;

@end
