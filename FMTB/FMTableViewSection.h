//
//  FMTableViewSection.h
//  FMTB
//
//  Created by 刘彬 on 16/9/20.
//  Copyright © 2016年 刘彬. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FMTableViewAdaptor;
@class FMBaseCellModel;

@interface FMTableViewSection : NSObject

// cellModel集合
@property (nonatomic, strong, readonly) NSMutableArray<FMBaseCellModel *> *items;
// 头部标题
@property (nonatomic, copy            ) NSString           *headerTitle;
// 底部标题
@property (nonatomic, copy            ) NSString           *footerTitle;
// 头部高度
@property (nonatomic, assign          ) CGFloat            headerHeight;
// 底部高度
@property (nonatomic, assign          ) CGFloat            footerHeight;
// 头部自定义view
@property (nonatomic, strong          ) UIView             *headerView;
// 底部自定义View
@property (nonatomic, strong          ) UIView             *footerView;
// 索引title
@property (nonatomic, copy            ) NSString           *indexTitle;
// tableview数据适配器
@property (nonatomic, weak            ) FMTableViewAdaptor *tableViewAdaptor;
// 在tableView中的位置
@property (nonatomic, assign, readonly) NSUInteger         indexAtTableView;

///-----------------------------
/// @ Initializes Methoh
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
/// @ Add Item Methoh
///-----------------------------
- (void)addItem:(FMBaseCellModel *)item;

- (void)addItemsFromArray:(NSArray<FMBaseCellModel *> *)array;

- (void)insertItem:(FMBaseCellModel *)item atIndex:(NSUInteger)index;

- (void)insertItems:(NSArray<FMBaseCellModel *> *)items atIndexes:(NSIndexSet *)indexes;

///-----------------------------
/// @ Remove Item Method
///-----------------------------
- (void)removeItem:(FMBaseCellModel *)item;

- (void)removeAllItems;

- (void)removeItemIdenticalTo:(FMBaseCellModel *)item inRange:(NSRange)range;

- (void)removeItemIdenticalTo:(FMBaseCellModel *)item;

- (void)removeItemsInArray:(NSArray<FMBaseCellModel *> *)otherArray;

- (void)removeItemsInRange:(NSRange)range;

- (void)removeItem:(FMBaseCellModel *)item inRange:(NSRange)range;

- (void)removeLastItem;

- (void)removeItemAtIndex:(NSUInteger)index;

- (void)removeItemsAtIndexes:(NSIndexSet *)indexes;

///-----------------------------
/// @ Replace Item Method
///-----------------------------
- (void)replaceItemAtIndex:(NSUInteger)index withItem:(FMBaseCellModel *)item;

- (void)replaceItemsWithItemsFromArray:(NSArray<FMBaseCellModel *> *)otherArray;

- (void)replaceItemsAtIndexes:(NSIndexSet *)indexes withItems:(NSArray<FMBaseCellModel *> *)items;

- (void)replaceItemsInRange:(NSRange)range withItemsFromArray:(NSArray<FMBaseCellModel *> *)otherArray range:(NSRange)otherRange;

- (void)replaceItemsInRange:(NSRange)range withItemsFromArray:(NSArray<FMBaseCellModel *> *)otherArray;

///-----------------------------
/// @ Exchange Item
///-----------------------------
- (void)exchangeItemAtIndex:(NSUInteger)idx1 withItemAtIndex:(NSUInteger)idx2;

///-----------------------------
/// @ Sort Item
///-----------------------------
- (void)sortItemsUsingFunction:(NSInteger (*)(FMBaseCellModel *item1, FMBaseCellModel *item2, void *))compare context:(void *)context;

- (void)sortItemsUsingSelector:(SEL)comparator;

- (void)reloadSectionWithAnimation:(UITableViewRowAnimation)animation;

@end
