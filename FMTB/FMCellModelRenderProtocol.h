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

/*!
 *  @brief 高度
 */
@property (nonatomic, assign) CGFloat cellHeight;

/*!
 *  @brief 左右边距
 */
@property (nonatomic, assign) CGFloat contentViewMargin;

/*!
 *  @brief 背景图左右边距
 */
@property (nonatomic, assign) CGFloat backgroundImageMargin;

/*!
 *  @brief 指示器类型
 */
@property (nonatomic, assign) UITableViewCellAccessoryType accessoryType;

/*!
 *  @brief 指示器视图
 */
@property (nonatomic, strong) UIView *accessoryView;

/*!
 *  @brief 选中状态的样式
 */
@property (nonatomic, assign) UITableViewCellSelectionStyle selectionStyle;

/*!
 *  @brief 编辑状态的样式
 */
@property (nonatomic, assign) UITableViewCellEditingStyle editingStyle;

/*!
 *  @brief 删除按钮文本
 */
@property (nonatomic, copy) NSString*deleteButtonTitle;


///-----------------------------
/// 底部分割线配置
///-----------------------------
/*!
 *  @brief 是否隐藏分割线
 */
@property (nonatomic, assign) BOOL hiddenSeparateLine;

/*!
 *  @brief 分割线颜色
 */
@property (nonatomic, strong) UIColor *separateLineColor;

/*!
 *  @brief 分割线高度
 */
@property (nonatomic, assign) CGFloat separateLineHeight;

/*!
 *  @brief 分割线左边距
 */
@property (nonatomic, assign) CGFloat separateLineLeftPadding;

/*!
 *  @brief 分割线右边距
 */
@property (nonatomic, assign) CGFloat separateLineRightPadding;

///-----------------------------
/// 背景配置
///-----------------------------
/*!
 *  @brief 背景色
 */
@property (nonatomic, strong) UIColor *normalBackgroundColor;

/*!
 *  @brief 选中状态的背景色
 */
@property (nonatomic, strong) UIColor *selectedBackgroundColor;

/*!
 *  @brief 背景图片
 */
@property (nonatomic, strong) UIImage *normalBackgroundImage;

/*!
 *  @brief 选中状态的背景图片
 */
@property (nonatomic, strong) UIImage *selectedBackgroundImage;

///-----------------------------
/// 默认控件的配置
///-----------------------------
@property (nonatomic, copy  ) NSString           *titleText;
@property (nonatomic, strong) UIFont             *titleFont;
@property (nonatomic, strong) UIColor            *titleColor;
@property (nonatomic, strong) NSAttributedString *titleAttrbuteString;
@property (nonatomic, strong) UIImage            *imageName;
@property (nonatomic, copy  ) NSString           *detailText;
@property (nonatomic, assign) NSTextAlignment    textAlignment;

@end
