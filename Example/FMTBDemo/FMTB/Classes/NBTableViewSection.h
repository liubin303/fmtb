//
//  NBTableViewSection.h
//  NBTableView
//
//  Created by 刘彬 on 16/3/11.
//  Copyright © 2016年 NewBee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NBTableViewCellStyle.h"
#import "NBTableViewCell.h"

@class NBTableViewAdaptor;
@class NBTableViewItem;

extern CGFloat const NBTableViewSectionHeaderHeightAutomatic;
extern CGFloat const NBTableViewSectionFooterHeightAutomatic;

/*!
 *  @brief tableViewSection
 */
@interface NBTableViewSection : NSObject

// section下的cellItem集合，只读，如需操作item请调用实例方法
@property (nonatomic, strong, readonly) NSArray<NBTableViewItem*> *items;
// 头部标题
@property (nonatomic, copy            ) NSString *headerTitle;
// 头部高度
@property (nonatomic, assign          ) CGFloat  headerHeight;
// 头部自定义view
@property (nonatomic, strong          ) UIView   *headerView;
// 底部标题
@property (nonatomic, copy            ) NSString *footerTitle;
// 底部高度
@property (nonatomic, assign          ) CGFloat  footerHeight;
// 底部自定义View
@property (nonatomic, strong          ) UIView   *footerView;
// 索引title
@property (nonatomic, copy            ) NSString *indexTitle;
// section下cell的默认样式
@property (nonatomic, strong          ) NBTableViewCellStyle *cellStyle;
// tableview数据适配器
@property (nonatomic, weak            ) NBTableViewAdaptor *tableViewAdaptor;
// 在tableView中的位置
@property (nonatomic, assign, readonly) NSUInteger         indexAtTableView;

///-----------------------------
/// @brief Initializes Method
///-----------------------------
+ (instancetype)section;

+ (instancetype)sectionWithHeaderTitle:(NSString *)headerTitle;

+ (instancetype)sectionWithHeaderTitle:(NSString *)headerTitle footerTitle:(NSString *)footerTitle;

+ (instancetype)sectionWithHeaderView:(UIView *)headerView;

+ (instancetype)sectionWithHeaderView:(UIView *)headerView footerView:(UIView *)footerView;

- (id)initWithHeaderTitle:(NSString *)headerTitle;

- (id)initWithHeaderTitle:(NSString *)headerTitle footerTitle:(NSString *)footerTitle;

- (id)initWithHeaderView:(UIView *)headerView;

- (id)initWithHeaderView:(UIView *)headerView footerView:(UIView *)footerView;

///-----------------------------
/// @brief Add Item Method
///-----------------------------
- (void)addItem:(NBTableViewItem *)item;

- (void)addItemsFromArray:(NSArray<NBTableViewItem *> *)array;

- (void)insertItem:(NBTableViewItem *)item atIndex:(NSUInteger)index;

- (void)insertItems:(NSArray<NBTableViewItem *> *)items atIndexes:(NSIndexSet *)indexes;

///-----------------------------
/// @brief Remove Item Method
///-----------------------------
- (void)removeItem:(NBTableViewItem *)item;

- (void)removeAllItems;

- (void)removeItemIdenticalTo:(NBTableViewItem *)item inRange:(NSRange)range;

- (void)removeItemIdenticalTo:(NBTableViewItem *)item;

- (void)removeItemsInArray:(NSArray<NBTableViewItem *> *)otherArray;

- (void)removeItemsInRange:(NSRange)range;

- (void)removeItem:(NBTableViewItem *)item inRange:(NSRange)range;

- (void)removeLastItem;

- (void)removeItemAtIndex:(NSUInteger)index;

- (void)removeItemsAtIndexes:(NSIndexSet *)indexes;

///-----------------------------
/// @brief Replace Item Method
///-----------------------------
- (void)replaceItemAtIndex:(NSUInteger)index withItem:(NBTableViewItem *)item;

- (void)replaceItemsWithItemsFromArray:(NSArray<NBTableViewItem *> *)otherArray;

- (void)replaceItemsAtIndexes:(NSIndexSet *)indexes withItems:(NSArray<NBTableViewItem *> *)items;

- (void)replaceItemsInRange:(NSRange)range withItemsFromArray:(NSArray<NBTableViewItem *> *)otherArray range:(NSRange)otherRange;

- (void)replaceItemsInRange:(NSRange)range withItemsFromArray:(NSArray<NBTableViewItem *> *)otherArray;

///-----------------------------
/// @brief Exchange Item Method
///-----------------------------
- (void)exchangeItemAtIndex:(NSUInteger)idx1 withItemAtIndex:(NSUInteger)idx2;

///-----------------------------
/// @brief Sort Item Method
///-----------------------------
- (void)sortItemsUsingFunction:(NSInteger (*)(NBTableViewItem *item1, NBTableViewItem *item2, void *))compare context:(void *)context;

- (void)sortItemsUsingSelector:(SEL)comparator;

- (void)reloadSectionWithAnimation:(UITableViewRowAnimation)animation;

@end
