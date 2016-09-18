//
//  NBTableViewCell.h
//  NBTableView
//
//  Created by 刘彬 on 16/3/10.
//  Copyright © 2016年 NewBee. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NBTableViewAdaptor.h"

@class NBTableViewSection;
@class NBTableViewAdaptor;
@class NBTableViewItem;

#pragma mark - ----------------------Font macros----------------------

#define HEL_8               [UIFont systemFontOfSize:8]
#define HEL_9               [UIFont systemFontOfSize:9]
#define HEL_10              [UIFont systemFontOfSize:10]
#define HEL_11              [UIFont systemFontOfSize:11]
#define HEL_12              [UIFont systemFontOfSize:12]
#define HEL_13              [UIFont systemFontOfSize:13]
#define HEL_14              [UIFont systemFontOfSize:14]
#define HEL_15              [UIFont systemFontOfSize:15]
#define HEL_16              [UIFont systemFontOfSize:16]
#define HEL_17              [UIFont systemFontOfSize:17]
#define HEL_18              [UIFont systemFontOfSize:18]
#define HEL_19              [UIFont systemFontOfSize:19]
#define HEL_20              [UIFont systemFontOfSize:20]
#define HEL_21              [UIFont systemFontOfSize:21]
#define HEL_22              [UIFont systemFontOfSize:22]
#define HEL_24              [UIFont systemFontOfSize:24]
#define HEL_30              [UIFont systemFontOfSize:30]
#define HEL_36              [UIFont systemFontOfSize:36]


#define HEL_BOLD_12         [UIFont boldSystemFontOfSize:12]
#define HEL_BOLD_13         [UIFont boldSystemFontOfSize:13]
#define HEL_BOLD_14         [UIFont boldSystemFontOfSize:14]
#define HEL_BOLD_15         [UIFont boldSystemFontOfSize:15]
#define HEL_BOLD_16         [UIFont boldSystemFontOfSize:16]
#define HEL_BOLD_18         [UIFont boldSystemFontOfSize:18]
#define HEL_BOLD_19         [UIFont boldSystemFontOfSize:19]
#define HEL_BOLD_20         [UIFont boldSystemFontOfSize:20]
#define HEL_BOLD_22         [UIFont boldSystemFontOfSize:22]
#define HEL_BOLD_24         [UIFont boldSystemFontOfSize:24]
#define HEL_BOLD_30         [UIFont boldSystemFontOfSize:30]

#pragma mark - ----------------------Common Font & Color----------------------

// 粗体文本字号
#define Biggest_Border_Font    HEL_BOLD_22
#define Biger_Border_Font      HEL_BOLD_18
#define Big_Border_Font        HEL_BOLD_16
#define Middle_Bold_Font       HEL_BOLD_15
#define Normal_Bold_Font       HEL_BOLD_14
#define Normal_Small_Bold_Font HEL_BOLD_12
// 普通文本字号
#define Biggest_Font           HEL_22
#define Biger_Font             HEL_18
#define Big_Font               HEL_16
#define Middle_Font            HEL_15
#define Normal_Font            HEL_13
#define Normal_Small_Font      HEL_12
#define Normal_Smaller_Font    HEL_11
#define Small_Font             HEL_10
#define Smaller_Font           HEL_9

// 默认文本颜色[标题文字，正文内容，对话内容]
#define COLOR_NORMAL_TEXT           [UIColor blackColor]
// 灰色文本颜色[状态文字，辅助文字]
#define COLOR_NORMAL_SUBINFO_TEXT   [UIColor grayColor]

/*!
 *  @brief Cell的位置类型
 */
typedef NS_ENUM(NSInteger, NBCellLocationType) {
    /*!
     *  第一行
     */
    NBCellLocationFirst,
    /*!
     *  中间一行
     */
    NBCellLocationMiddle,
    /*!
     *  最后一行
     */
    NBCellLocationLast,
    /*!
     *  唯一一行
     */
    NBCellLocationSingle,
    /*!
     *  其他行
     */
    NBCellLocationAny
};

/*!
 *  @brief cell基类
 */
@interface NBTableViewCell : UITableViewCell
// 依赖的tableView
@property (nonatomic, weak) UITableView        *parentTableView;
// 依赖的tableViewAdaptor
@property (nonatomic, weak) NBTableViewAdaptor *tableViewAdaptor;
// 依赖的section
@property (nonatomic, weak) NBTableViewSection *section;
// cell对应的item
@property (nonatomic, strong) NBTableViewItem *item;
// 是否已经初始化
@property (nonatomic, assign, readonly) BOOL loaded;
// 可响应的控件
@property (nonatomic, strong, readonly) UIResponder *responder;
// 上一个控件的位置
@property (nonatomic, strong, readonly) NSIndexPath *indexPathForPreviousResponder;
// 下一个控件的位置
@property (nonatomic, strong, readonly) NSIndexPath *indexPathForNextResponder;
// cell的位置类型
@property (nonatomic, assign, readonly) NBCellLocationType locationType;
// cell的位置索引
@property (nonatomic, assign) NSInteger rowIndex;
// section的位置索引
@property (nonatomic, assign) NSInteger sectionIndex;

///-----------------------------
/// @brief cell life cycle
///-----------------------------
- (void)cellDidLoad __attribute__((objc_requires_super));
- (void)cellWillAppear __attribute__((objc_requires_super));
- (void)cellDidDisappear __attribute__((objc_requires_super));

/*!
 *  @brief cell高度的计算方法
 *
 *  @param tableView cell所属的tableView
 *  @param item      cell绑定的item
 *
 *  @return cell高度
 */
+ (CGFloat)tableView:(UITableView*)tableView heightForRowByItem:(NBTableViewItem*)item;

- (void)updateActionBarNavigationControl;
- (void)layoutDetailView:(UIView *)view;
+ (BOOL)canFocusWithItem:(NBTableViewItem *)item;

@end
