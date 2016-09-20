//
//  FMTableViewAdaptor.h
//  FMTB
//
//  Created by 刘彬 on 16/9/20.
//  Copyright © 2016年 刘彬. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMBaseCellModel;
@class FMTableViewSection;

@protocol FMTableViewAdaptorDelegate <UITableViewDelegate>

@optional
///-----------------------------
/// @ cell select
///-----------------------------
- (void)tableView:(UITableView *)tableView didSelectItem:(FMBaseCellModel*)item rowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didSelectItem:(FMBaseCellModel*)item cell:(UITableViewCell *)cell;

///-----------------------------
/// @ cell edit
///-----------------------------
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forItem:(FMBaseCellModel*)item atIndexPath:(NSIndexPath *)indexPath;
- (BOOL)tableView:(UITableView *)tableView canEditItem:(FMBaseCellModel*)item atIndexPath:(NSIndexPath *)indexPath;

///-----------------------------
/// @ cell display
///-----------------------------
- (void)tableView:(UITableView *)tableView willLayoutCellSubviews:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView willLoadCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didLoadCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

///-----------------------------
/// @ load data
///-----------------------------
// 是否正在加载数据
- (BOOL)tableViewDataIsLoading:(UITableView *)tableView;
// 下拉刷新数据
- (void)tableViewTriggerRefresh:(UITableView *)tableView;
// 加载更多数据
- (void)tableViewLoadMoreData:(UITableView *)tableView;

@end

@interface FMTableViewAdaptor : NSObject<UITableViewDataSource,UITableViewDelegate>

// tableview
@property (nonatomic, strong) UITableView *tableView;
// 下拉刷新控制
@property (nonatomic, assign) BOOL dragRefreshEnable;
// 上拉刷新控制
@property (nonatomic, assign) BOOL loadMoreEnable;
// 处理tableview的代理
@property (nonatomic, weak) id<FMTableViewAdaptorDelegate> delegate;
// 绑定的section集合
@property (nonatomic, strong, readonly) NSMutableArray<FMTableViewSection*> *sections;

///-----------------------------
/// @ Initializes Methoh
///-----------------------------
- (id)initWithTableView:(UITableView *)tableView;

// 重置section
- (void)resetSections:(NSArray<FMTableViewSection*> *)sections;

// 加载数据完成
- (void)finishLoadingData;

///-----------------------------
/// @ Adding sections
///-----------------------------
- (void)addSection:(FMTableViewSection *)section;

- (void)addSectionsFromArray:(NSArray<FMTableViewSection*> *)array;

- (void)insertSection:(FMTableViewSection *)section atIndex:(NSUInteger)index;

- (void)insertSections:(NSArray<FMTableViewSection*> *)sections atIndexes:(NSIndexSet *)indexes;

///-----------------------------
/// @ Removing Sections
///-----------------------------

- (void)removeSection:(FMTableViewSection *)section;

- (void)removeAllSections;

- (void)removeSectionIdenticalTo:(FMTableViewSection *)section inRange:(NSRange)range;

- (void)removeSectionIdenticalTo:(FMTableViewSection *)section;

- (void)removeSectionsInArray:(NSArray<FMTableViewSection*> *)otherArray;

- (void)removeSectionsInRange:(NSRange)range;

- (void)removeSection:(FMTableViewSection *)section inRange:(NSRange)range;

- (void)removeLastSection;

- (void)removeSectionAtIndex:(NSUInteger)index;

- (void)removeSectionsAtIndexes:(NSIndexSet *)indexes;

///-----------------------------
/// @ Replacing Sections
///-----------------------------

- (void)replaceSectionAtIndex:(NSUInteger)index withSection:(FMTableViewSection *)section;

- (void)replaceSectionsWithSectionsFromArray:(NSArray<FMTableViewSection*> *)otherArray;

- (void)replaceSectionsAtIndexes:(NSIndexSet *)indexes withSections:(NSArray<FMTableViewSection*> *)sections;

- (void)replaceSectionsInRange:(NSRange)range withSectionsFromArray:(NSArray<FMTableViewSection*> *)otherArray range:(NSRange)otherRange;

- (void)replaceSectionsInRange:(NSRange)range withSectionsFromArray:(NSArray<FMTableViewSection*> *)otherArray;

///-----------------------------
/// @ Rearranging Sections
///-----------------------------

- (void)exchangeSectionAtIndex:(NSUInteger)idx1 withSectionAtIndex:(NSUInteger)idx2;

- (void)sortSectionsUsingFunction:(NSInteger (*)(id, id, void *))compare context:(void *)context;

- (void)sortSectionsUsingSelector:(SEL)comparator;

@end
