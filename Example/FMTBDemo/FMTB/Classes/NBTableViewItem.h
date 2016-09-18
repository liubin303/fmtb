//
//  NBTableViewItem.h
//  NBTableView
//
//  Created by 刘彬 on 16/3/11.
//  Copyright © 2016年 NewBee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NBTableViewSection.h"

typedef NS_ENUM(NSInteger,TrustType) {
    TrustTypeOff    = 0,
    TrustTypeOn     = 1
};

@interface NBTableViewItem : NSObject
// cell的类
@property (nonatomic, strong          ) Class                         cellClass;
// cell的字符串标识
@property (nonatomic, copy            ) NSString                      *cellIdentifier;
// cell的数字标识，最好是定义枚举
@property (nonatomic, assign          ) NSInteger                     cellTag;
// cell 默认控件的配置
@property (nonatomic, copy            ) NSString                      *title;
@property (nonatomic, strong          ) NSAttributedString            *titleAttrbuteString;
@property (nonatomic, strong          ) UIFont                        *titleFont;
@property (nonatomic, strong          ) UIColor                       *titleColor;
@property (nonatomic, strong          ) UIImage                       *image;
@property (nonatomic, copy            ) NSString                      *detailText;
@property (nonatomic, assign          ) NSTextAlignment               textAlignment;
// 是否响应用户操作
@property (nonatomic, assign          ) BOOL                          userInteractionEnabled;
// cell选择的样式(如果要自定义颜色，请不要设置改值为UITableViewCellSelectionStyleNone)
@property (nonatomic, assign          ) UITableViewCellSelectionStyle selectionStyle;
// cell编辑的样式
@property (nonatomic, assign          ) UITableViewCellEditingStyle   editingStyle;
// 是否需要立即删除cell
@property (nonatomic, assign          ) BOOL shouldDeleteRightNow;
// cell指示器类型
@property (nonatomic, assign          ) UITableViewCellAccessoryType  accessoryType;
// cell指示器视图
@property (nonatomic, strong          ) UIView                        *accessoryView;
// cell删除按钮文本
@property (nonatomic, copy            ) NSString                      *deleteButtonTitle;
// cell的高度
@property (nonatomic, assign          ) CGFloat                       cellHeight;
// 边距
@property (nonatomic, assign          ) CGFloat                       contentViewMargin;
@property (nonatomic, assign          ) CGFloat                       backgroundImageMargin;

// 是否使用xib
@property (nonatomic, assign          ) BOOL                          useNib;
// 分割线配置
@property (nonatomic, assign          ) BOOL                          hiddenSeparateLine;
@property (nonatomic ,strong          ) UIColor                       *separateLineColor;
@property (nonatomic ,assign          ) CGFloat                       separateLineHeight;
@property (nonatomic, assign          ) CGFloat                       separateLineLeftPadding;
@property (nonatomic, assign          ) CGFloat                       separateLineRightPadding;
// 背景色配置
@property (nonatomic, strong          ) UIColor                       *backgroundColor;
@property (nonatomic, strong          ) UIColor                       *selectedBackgroundColor;
@property (nonatomic, strong          ) UIColor                       *contentViewBackgroundColor;

// 背景图
@property (nonatomic, strong          ) UIImage                       *backgroundImage;
@property (nonatomic, strong          ) UIImage                       *selectedBackgroundImage;
// cell的响应对象
@property (nonatomic, assign          ) id                            cellSelResponse;
// 所属的section和位置
@property (nonatomic, weak            ) NBTableViewSection            *section;
@property (nonatomic, strong, readonly) NSIndexPath                   *indexPath;
// 事件的handler
@property (nonatomic, copy) void (^selectionHandler)(id item);
@property (nonatomic, copy) void (^accessoryButtonTapHandler)(id item);
@property (nonatomic, copy) void (^insertionHandler)(id item);
@property (nonatomic, copy) void (^deletionHandler)(id item);
@property (nonatomic, copy) void (^deletionHandlerWithCompletion)(id item, void (^)(void));
@property (nonatomic, copy) BOOL (^moveHandler)(id item, NSIndexPath *sourceIndexPath, NSIndexPath *destinationIndexPath);
@property (nonatomic, copy) void (^moveCompletionHandler)(id item, NSIndexPath *sourceIndexPath, NSIndexPath *destinationIndexPath);
@property (nonatomic, copy) void (^cutHandler)(id item);
@property (nonatomic, copy) void (^copyHandler)(id item);
@property (nonatomic, copy) void (^pasteHandler)(id item);

@property (nonatomic, copy) void (^actionBarNavButtonTapHandler)(id item); //handler for nav button on ActionBar
@property (nonatomic, copy) void (^actionBarDoneButtonTapHandler)(id item); //handler for done button on ActionBar

///-----------------------------
/// @name Initializes Methoh
///-----------------------------
+ (instancetype)item;
- (id)initWithDefault;

///-----------------------------
/// @name Operation Cell
///-----------------------------
- (void)selectRowAnimated:(BOOL)animated;
- (void)selectRowAnimated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition;
- (void)deselectRowAnimated:(BOOL)animated;
- (void)reloadRowWithAnimation:(UITableViewRowAnimation)animation;
- (void)deleteRowWithAnimation:(UITableViewRowAnimation)animation;

@end
