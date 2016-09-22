//
//  FMCellModelRenderProtocol.h
//  FMTB
//
//  Created by 刘彬 on 16/9/20.
//  Copyright © 2016年 刘彬. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*!
 *  @brief cell渲染相关的属性
 */
@protocol FMCellModelRenderProtocol <NSObject>

///-----------------------------
/// 基础样式配置
///-----------------------------
/*!
 *  @brief 高度
 *  @default 0
 */
@property (nonatomic, assign) CGFloat cellHeight;

/*!
 *  @brief 内容左右边距
 *  @default 0
 */
@property (nonatomic, assign) CGFloat contentViewMargin;

/*!
 *  @brief 背景图左右边距
 *  @default 0
 */
@property (nonatomic, assign) CGFloat backgroundImageMargin;

/*!
 *  @brief 选中状态的样式
 *  @default UITableViewCellSelectionStyleDefault
 */
@property (nonatomic, assign) UITableViewCellSelectionStyle selectionStyle;

/*!
 *  @brief 编辑状态的样式
 *  @default UITableViewCellEditingStyleNone
 */
@property (nonatomic, assign) UITableViewCellEditingStyle editingStyle;

/*!
 *  @brief 删除按钮文本
 *  @default 删除
 */
@property (nonatomic, copy) NSString*deleteButtonTitle;


///-----------------------------
/// 底部分割线配置
///-----------------------------
/*!
 *  @brief 是否隐藏分割线
 *  @default NO
 */
@property (nonatomic, assign) BOOL hiddenSeparateLine;

/*!
 *  @brief 分割线颜色
 *  @default [UIColor blackColor]
 */
@property (nonatomic, strong) UIColor *separateLineColor;

/*!
 *  @brief 分割线高度
 *  @default 1px
 */
@property (nonatomic, assign) CGFloat separateLineHeight;

/*!
 *  @brief 分割线左边距
 *  @default 0
 */
@property (nonatomic, assign) CGFloat separateLineLeftPadding;

/*!
 *  @brief 分割线右边距
 *  @default 0
 */
@property (nonatomic, assign) CGFloat separateLineRightPadding;

///-----------------------------
/// 右边icon配置
///-----------------------------
/*!
 *  @brief 是否隐藏icon
 *  @default NO
 */
@property (nonatomic, assign) BOOL hiddenRightArrow;

/*!
 *  @brief 箭头右边间距
 *  @default 10
 */
@property (nonatomic, assign) CGFloat rightArrowRightPadding;

/*!
 *  @brief 箭头自定义图片
 *  @default 默认灰色箭头
 */
@property (nonatomic, strong) UIImage *customArrowImage;


///-----------------------------
/// 背景配置
///-----------------------------
/*!
 *  @brief 背景色
 *  @default [UIColor whiteColor]
 */
@property (nonatomic, strong) UIColor *normalBackgroundColor;

/*!
 *  @brief 选中状态的背景色
 *  @default [UIColor lightGrayColor]
 */
@property (nonatomic, strong) UIColor *selectedBackgroundColor;

/*!
 *  @brief 背景图片
 *  @default nil
 */
@property (nonatomic, strong) UIImage *normalBackgroundImage;

/*!
 *  @brief 选中状态的背景图片
 *  @default nil
 */
@property (nonatomic, strong) UIImage *selectedBackgroundImage;

@end
